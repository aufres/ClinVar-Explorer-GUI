import tkinter as tk
from tkinter import ttk
import pymysql

# --- DATABASE SETTINGS ---
# Add connection parameters and data fetching before UI initialization
DB_CONFIG = {
    "host": "localhost",
    "user": "tempuser",
    "password": "",
    "database": "clinvar",
    "port": 3306
}

# --- FUNCTION DEFINITIONS ---
# Define the functions needed for the GUI

def fetch_clinical_data():
    try:
        conn = pymysql.connect(**DB_CONFIG)
        cursor = conn.cursor()
        # Tweak: Replace 'gene_col', etc., with your actual column names from 'clinical_association'
        query = """SELECT GeneSymbol, NULL AS AlleleID, NULL AS DiseaseName FROM clinvar.gene UNION ALL SELECT NULL, AlleleID, NULL FROM clinvar.variant UNION ALL SELECT NULL, NULL, DiseaseName FROM clinvar.disease"""
        cursor.execute(query)
        data = cursor.fetchall()
        conn.close()
        return data
    except Exception as e:
        print(f"Database Error: {e}")
        return []

# Fetch the data once to distribute into listboxes
db_rows = fetch_clinical_data()


def execute_advanced_search():
    # 1. Clear the treeview first
    for item in tab2.results_tree.get_children():
        tab2.results_tree.delete(item)

    # 2. Build the Base Query with Joins
    # We join all 4 tables to get the names/symbols instead of just IDs
    query = """SELECT g.GeneSymbol, v.AlleleID, ca.ClinicalSignificance, d.DiseaseName FROM clinvar.clinical_association ca JOIN clinvar.variant v ON ca.VariantID = v.VariantID JOIN clinvar.gene g ON v.GeneID = g.GeneID JOIN clinvar.disease d ON ca.DiseaseID = d.DiseaseID"""

    conditions = []
    params = []

    # 3. Handle Checkbox Logic (Significance Filter)
    active_filters = []
    if tab2.pathogenic_var.get(): active_filters.append('Pathogenic')
    if tab2.benign_var.get(): active_filters.append('Benign')
    if tab2.vus_var.get(): active_filters.append('Uncertain significance')

    if active_filters:
        # Creates: ClinicalSignificance IN ('Pathogenic', 'Benign')
        placeholders = ', '.join(['%s'] * len(active_filters))
        conditions.append(f"ca.ClinicalSignificance IN ({placeholders})")
        params.extend(active_filters)

    # 4. Handle Search Term (LIKE Search)
    search_term = tab2.search_entry.get().strip()
    if search_term:
        # Search across Gene, Variant, or Disease names
        search_condition = "(g.GeneSymbol LIKE %s OR v.AlleleID LIKE %s OR d.DiseaseName LIKE %s)"
        conditions.append(search_condition)
        # Add % for wildcard search
        term = f"%{search_term}%"
        params.extend([term, term, term])

    # 5. Assemble WHERE clause
    if conditions:
        query += " WHERE " + " AND ".join(conditions)

    # 6. Execute and Populate
    try:
        conn = pymysql.connect(**DB_CONFIG)
        cursor = conn.cursor()
        cursor.execute(query, params)
        rows = cursor.fetchall()

        for row in rows:
            tab2.results_tree.insert("", tk.END, values=row)

        conn.close()
    except Exception as e:
        print(f"Database Error: {e}")

def clear_search():
    # Get all items in the treeview and delete them
    for item in tab2.results_tree.get_children():
        tab2.results_tree.delete(item)
    for col in tab2.results_tree['columns']:
        current_text = tab2.results_tree.heading(col, 'text')
        clean_text = current_text.replace(" ▲", "").replace(" ▼", "")
        tab2.results_tree.heading(col, text=clean_text)

# Global variable to remember the "starting point" of the shift
last_selected_index = None

def multi_highlight(event):
    global last_selected_index
    lb = event.widget
    current_index = lb.nearest(event.y)
    # Check if Shift key is held (0x0001) AND we have a previous click to start from
    if event.state & 0x0001 and last_selected_index is not None:
        start = min(last_selected_index, current_index)
        end = max(last_selected_index, current_index)
        # Determine the toggle action:
        # If the item you just clicked is already selected, we UNSELECT the range.
        # Otherwise, we SELECT the range.
        if lb.selection_includes(current_index):
            lb.selection_clear(start, end)
        else:
            lb.selection_set(start, end)
        # Update anchor but stay in range mode
        last_selected_index = current_index
        return "break"
    # If it's a normal click (no shift), just update the anchor
    last_selected_index = current_index

def handle_global_click(event):
    # Only shift focus if the widget clicked is the background (the root or a frame)
    if event.widget == root or isinstance(event.widget, (tk.Frame, ttk.Frame)):
        root.focus_set()

def toggle_selection(event):
    # Identify which row was clicked
    item = tree.identify_row(event.y)
    if item:
        # Toggle the selection state for just this item
        tree.selection_toggle(item)

def master_deselect(event=None):
    # --- Reset Listbox Anchors & Selections (Tab 1) ---
    global last_selected_index
    last_selected_index = None
    for lb in listboxes:
        lb.selection_clear(0, tk.END)
        lb.activate(-1)

    # --- Reset Treeview Anchor & Tags (Tab 2) ---
    global last_tree_anchor
    last_tree_anchor = None
    for item in tab2.results_tree.get_children():
        tab2.results_tree.item(item, tags=())

    # Return "break" to prevent default system behavior (like beeping)
    return "break"


# --- COPY/PASTE LOGIC ---
def copy_selection(widget):
    """Explicitly grabs the selected items from the right-clicked widget."""
    root.clipboard_clear()

    if isinstance(widget, tk.Listbox):
        # Get indices of all highlighted items
        indices = widget.curselection()
        if indices:
            # Fetch the actual strings from the listbox using the indices
            selected_items = [widget.get(i) for i in indices]
            # Join them (e.g., "ID1, ID2") and put them on the clipboard
            text_to_copy = ", ".join(map(str, selected_items))
            root.clipboard_append(text_to_copy)
            # This 'update' ensures the clipboard is available to other apps/tabs immediately
            root.update()

def paste_to_search(widget):
    # Pastes clipboard content into the search entry.
    try:
        clipboard_text = root.clipboard_get()
        widget.delete(0, tk.END)
        widget.insert(0, clipboard_text)
    except tk.TclError:
        pass  # Clipboard empty

def show_context_menu(event, widget, mode):
    # Displays the right-click menu.
    menu = tk.Menu(root, tearoff=0)
    if mode == "copy":
        menu.add_command(label="Copy Selection", command=lambda: copy_selection(widget))
    elif mode == "paste":
        menu.add_command(label="Paste", command=lambda: paste_to_search(widget))

    menu.post(event.x_root, event.y_root)


# --- INITIALIZE MAIN WINDOW & NOTEBOOK ---
# Main window setup
root = tk.Tk()
root.title("ClinVar Variant-Disease Explorer")
root.geometry("1200x500")

# Create Notebook (Tab Control)
notebook = ttk.Notebook(root)
notebook.pack(expand=True, fill="both", padx=10, pady=10)


# --- TAB 1: LISTBOXES ---
tab1 = ttk.Frame(notebook)
notebook.add(tab1, text="Browse Database")

# Configure weights for Tab 1
for i in range(3):
    tab1.columnconfigure(i, weight=1)

# Make row containing listboxes expand vertically
tab1.rowconfigure(1, weight=1)

# Define header names for the columns
# header_vars = []
headers = ["Genes", "Variant IDs", "Associated Diseases"]

# Create list to hold your listbox widgets (place this before loop)
listboxes = []


for i, title in enumerate(headers):
    # Initialize StringVar with header name
    # var = tk.StringVar(value=header)
    # header_vars.append(var)

    # Create a frame for each column unit
    col_frame = tk.Frame(tab1)

    # Add sticky="nsew" to make the frame fill the grid cell
    col_frame.grid(row=1, column=i, padx=5, pady=5, sticky="nsew")

    # Add the headers
    tk.Label(col_frame, text=title, font=('Arial', 12, 'bold'), pady=5).pack()

    # Create scrollbar (sb) and listbox (lb) inside the frame (col_frame)
    sb = tk.Scrollbar(col_frame)
    sb.pack(side=tk.RIGHT, fill=tk.Y)

    lb = tk.Listbox(col_frame, font=('Consolas', 10), selectmode=tk.MULTIPLE, exportselection=0, yscrollcommand=sb.set)
    # Append listbox after creating it:
    listboxes.append(lb)
    lb.pack(side=tk.LEFT, expand=True, fill="both")

    # Link together scrollbars and listboxes
    sb.config(command=lb.yview)

    # --- POPULATE LISTBOX ---
    # Iterate through fetched DB rows and grab the index (i) matching current column index in the loop.
    for row in db_rows:
        if len(row) > i and row[i] is not None:  # Added 'is not None' check
            lb.insert(tk.END, row[i])

    # Bind the multi_highlight event
    lb.bind("<Button-1>", multi_highlight)
    # Bind right-click to copy
    lb.bind("<Button-3>", lambda e, w=lb: show_context_menu(e, w, "copy"))

# --- TAB 2: TREEVIEW ---
tab2 = ttk.Frame(notebook)
notebook.add(tab2, text="Advanced Search")

# Make Column 0 fill the width, and Row 1 (Treeview) fill the height
tab2.columnconfigure(0, weight=1)
tab2.rowconfigure(1, weight=1)

# Top Search Bar Area
search_frame = ttk.LabelFrame(tab2, text="Query Parameters")
search_frame.grid(row=0, column=0, padx=10, pady=10, sticky="ew")

ttk.Label(search_frame, text="Search Term:").grid(row=0, column=0, padx=5, pady=5, sticky="w")
tab2.search_entry = ttk.Entry(search_frame, width=40)
tab2.search_entry.grid(row=0, column=1, padx=5, pady=5, sticky="w")

# Bind right-click to paste
tab2.search_entry.bind("<Button-3>", lambda e, w=tab2.search_entry: show_context_menu(e, w, "paste"))

# Configuring Checkbuttons
filter_frame = ttk.Frame(search_frame)
filter_frame.grid(row=1, column=0, columnspan=3, pady=10, sticky="w")

tab2.pathogenic_var = tk.BooleanVar(value=True)
tab2.benign_var = tk.BooleanVar()
tab2.vus_var = tk.BooleanVar()

ttk.Checkbutton(filter_frame, text="Pathogenic", variable=tab2.pathogenic_var).grid(row=0, column=0, padx=(70, 10))
ttk.Checkbutton(filter_frame, text="Benign", variable=tab2.benign_var).grid(row=0, column=1, padx=(10))
ttk.Checkbutton(filter_frame, text="VUS (Unknown)", variable=tab2.vus_var).grid(row=0, column=2, padx=(10))

btn_search = ttk.Button(search_frame, text="Run SQL Query")
btn_search.grid(row=0, column=2, padx=5, pady=5)

btn_clear = ttk.Button(search_frame, text="Clear", width=6)
btn_clear.grid(row=0, column=3, padx=5, pady=5)

# Configuring Treeview
columns = ("col1", "col2", "col3")
tree = ttk.Treeview(tab2, columns=columns, show="headings", selectmode="none")

table_frame = ttk.Frame(tab2)
table_frame.grid(row=1, column=0, sticky="nsew", padx=10, pady=5)

table_frame.columnconfigure(0, weight=1)
table_frame.rowconfigure(0, weight=1)

cols = ("Gene", "Variant ID", "Significance", "Disease")
tab2.results_tree = ttk.Treeview(table_frame, columns=cols, show='headings')

# Define a tag color (right after creating the treeview)
tab2.results_tree.tag_configure('checked', background='#0078d7', foreground='white')

# Define toggle_tree_selection for more granular selection options
def toggle_tree_selection(event):
    tree = event.widget
    item_id = tree.identify_row(event.y)

    if item_id:
        # Check if the item already has the 'checked' tag
        tags = tree.item(item_id, 'tags')

        if 'checked' in tags:
            # If it's already highlighted, remove the tag
            tree.item(item_id, tags=())
        else:
            # If it's not highlighted, add the 'checked' tag
            tree.item(item_id, tags=('checked',))

    # Return break to stop focus from sticking to the row
    return "break"

# Define sort_treeview_column to sort column data alphabetically (with up/down arrows)
def sort_treeview_column(tree, col, reverse):
    # Get data and IDs
    data = []
    for item_id in tree.get_children(''):
        # Get the value from the specific column
        val = tree.set(item_id, col)
        try:
            # Handle numerical sorting
            val = float(val)
        except ValueError:
            val = val.lower()
        data.append((val, item_id))

    # Perform sort
    data.sort(reverse=reverse)

    # Physically move rows in the UI
    for index, (val, item_id) in enumerate(data):
        tree.move(item_id, '', index)

    # Update Headers and add Arrows
    # 'tree["columns"]' returns the list of IDs used when the tree was created
    for col_id in tree['columns']:
        # Retrieve the current text (which might already have an arrow)
        current_header_text = tree.heading(col_id, 'text')

        # Clean old arrows
        clean_text = current_header_text.replace(" ▲", "").replace(" ▼", "")

        if col_id == col:
            # Active column - add correct arrow
            new_arrow = " ▼" if reverse else " ▲"
            tree.heading(col_id, text=clean_text + new_arrow,
                         command=lambda _c=col_id: sort_treeview_column(tree, _c, not reverse))
        else:
            # Reset other columns to clean text
            tree.heading(col_id, text=clean_text,
                         command=lambda _c=col_id: sort_treeview_column(tree, _c, False))


# Format column headings
for col in cols:
    tab2.results_tree.heading(col, text=col, command=lambda _col=col: sort_treeview_column(tab2.results_tree, _col, False))
    tab2.results_tree.column(col, width=150, anchor="center")

# Add a scrollbar to the table
tree_scroll = ttk.Scrollbar(table_frame, orient="vertical", command=tab2.results_tree.yview)
tab2.results_tree.configure(yscrollcommand=tree_scroll.set)

tab2.results_tree.grid(row=0, column=0, sticky="nsew")
tree_scroll.grid(row=0, column=1, sticky="ns")

# Link the search button to execute_advanced_search function
btn_search.config(command=execute_advanced_search)
# Also trigger search when 'Enter' is pressed in the search box
tab2.search_entry.bind("<Return>", lambda e: execute_advanced_search())
# Link the 'clear' button to clear_search function
btn_clear.config(command=clear_search)

# Track the last row ID clicked in the Treeview
last_tree_anchor = None

# Define custom toggle (left click) highlight clicking for Treeview
def handle_tree_range_toggle(event):
    global last_tree_anchor
    tree = event.widget
    item_id = tree.identify_row(event.y)

    if not item_id:
        return

    # Get all current rows in order to calculate the range
    all_items = tree.get_children('')

    # Check if Shift is held and we have a starting point
    if event.state & 0x0001 and last_tree_anchor in all_items:
        idx1 = all_items.index(last_tree_anchor)
        idx2 = all_items.index(item_id)

        start = min(idx1, idx2)
        end = max(idx1, idx2)

        # Determine toggle action: if the clicked item is highlighted, we deselect the range
        is_selected = 'checked' in tree.item(item_id, 'tags')

        for i in range(start, end + 1):
            target_id = all_items[i]
            if is_selected:
                tree.item(target_id, tags=())
            else:
                tree.item(target_id, tags=('checked',))
    else:
        # Standard single-click toggle
        if 'checked' in tree.item(item_id, 'tags'):
            tree.item(item_id, tags=())
        else:
            tree.item(item_id, tags=('checked',))

    last_tree_anchor = item_id
    return "break"

# Bind the custom toggle (left-click) function for Treeview
tab2.results_tree.bind("<Button-1>", toggle_tree_selection)
# Bind the Shift-Click toggle for Treeview
tab2.results_tree.bind("<Button-1>", handle_tree_range_toggle)

# Bind master_deselect for all tabs
root.bind("<Control-d>", master_deselect)
root.bind("<Control-D>", master_deselect)
root.bind("<Escape>", master_deselect)
# Bind global_click for all tabs
root.bind("<Button-1>", handle_global_click)

root.mainloop()
