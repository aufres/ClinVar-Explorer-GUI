# ClinVar Variant-Disease Explorer

A Python desktop GUI application built with `tkinter` and `pymysql` for browsing and searching genetic variants, genes, and disease associations from a local ClinVar MySQL database. 

## 🧬 Overview

This tool provides a user-friendly interface to query a local instance of the ClinVar database. It abstracts complex SQL joins and filtering into a dual-tab visual explorer, making it easy to search for specific genetic variants, filter by clinical significance, and export selected data items to your clipboard.

## ✨ Features

* **Dual-Tab Interface:**
    * **Browse Database (Tab 1):** Scroll through master lists of Genes, Variant IDs, and Associated Diseases.
    * **Advanced Search (Tab 2):** Perform deep searches with dynamic SQL querying and filtering.
* **Advanced Filtering:** Filter variants by Clinical Significance (Pathogenic, Benign, VUS/Unknown) alongside a text-based wildcard search across genes, variants, and disease names.
* **Interactive Data Tables:**
    * Clickable column headers to sort data alphabetically or numerically.
    * Custom multi-selection logic (Left-Click toggle, Shift-Click range selection).
* **Quality of Life Shortcuts:**
    * Right-click context menus to easily **Copy** from the database lists and **Paste** into the search bar.
    * Use `Ctrl+D` or `Escape` to instantly clear all current selections across both tabs.

## 🛠️ Prerequisites

To run this application, you need Python 3.x and the following requirements.

1. **Python Packages**

Install the required database connector via pip:

```bash
pip install pymysql
```
2.  **MySQL Database:** You must have a local MySQL server running with a database named `clinvar`. 
    The application expects the following tables and relationships:
    * `gene` (`GeneID`, `GeneSymbol`)
    * `variant` (`VariantID`, `GeneID`, `AlleleID`)
    * `disease` (`DiseaseID`, `DiseaseName`)
    * `clinical_association` (`VariantID`, `DiseaseID`, `ClinicalSignificance`)

## 🚀 Setup and Usage

1.  **Configure Database Credentials:**
    Open the script and update the `DB_CONFIG` dictionary at the top of the file to match your local MySQL server credentials:
```python
    DB_CONFIG = {
        "host": "localhost",
        "user": "tempuser",       # Update this
        "password": "",           # Update this
        "database": "clinvar",
        "port": 3306
    }
```    

2.  **Run the Application:**
Execute the script from your terminal:
```bash
    python clinvar_explorer.py
```    

## ⌨️ Keyboard & Mouse Controls

| Action | Input | Description |
| :--- | :--- | :--- |
| **Toggle Selection** | `Left-Click` | Highlights or un-highlights a specific row. |
| **Range Selection** | `Shift + Left-Click` | Selects a bulk range of items between your last click and current click. |
| **Context Menu** | `Right-Click` | Opens a menu to Copy highlighted items (Tab 1) or Paste text (Tab 2 Search). |
| **Clear All** | `Ctrl + D` or `Esc` | Drops all current selections/highlights across the entire application. |
| **Run Search** | `Enter` | Executes the SQL query while focused in the Search bar. |
