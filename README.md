# Job Marketplace Analysis using SQL (SQLite)

## 📌 Project Overview

This project analyzes a job marketplace dataset to understand **user behavior, job demand, and hiring funnel drop-offs**.  
The goal is to identify insights that can help **increase successful hires** using SQL-based analytics.

---

## 🛠 Tools & Technologies
- Excel
- SQL (SQLite)
- Python (Jupyter Notebook for data loading)
- VS Code
- Git & GitHub

---

## 📂 Dataset & Encoding Fix (Important Step)

The original dataset contained **Windows-1252 encoded characters** (smart quotes, special symbols), which caused import errors in SQLite.

### ✅ Solution:

- Converted the dataset encoding from **Windows-1252 to UTF-8**
- Ensured clean imports without character or column mismatch issues

> This step was critical to avoid `UnicodeDecodeError` and data corruption.

---


## 🔄 Step-by-Step Workflow

### 1️⃣ Data Cleaning & Encoding
- Used Excel prior for cleaning
- Verified CSV encoding
- Converted to UTF-8
- Removed malformed rows and ensured column consistency

### 2️⃣ Database Setup

- Created raw staging table (`jobs_raw`)
- Loaded cleaned CSV into SQLite database

### 3️⃣ Data Modeling

- Used **raw → analytical query approach**
- Avoided modifying original data
- Created views for analysis

### 4️⃣ SQL Analysis Performed

#### 🔹 Funnel Conversion Analysis

- Views → Applies → Hires
- Identified drop-off points

#### 🔹 Cohort Analysis

- Grouped jobs by posting month
- Tracked application behavior over time

#### 🔹 Job Success Ranking

- Ranked jobs by applies-to-views ratio

#### 🔹 City & Skill Demand

- Identified top hiring cities
- Most in-demand skills

#### 🔹 Median Time-to-Hire

- Calculated time between posting and application peaks

---

## ▶️ How to Run This Project

### Step 1: Create SQLite Database

An empty SQLite database was created:

```bash
jobs.db
```

### Step 2: Import Dataset using Jupyter Notebook

The CSV dataset was loaded using Python (Pandas)
Data was inserted into SQLite tables programmatically
This step ensured:

- Correct column mapping
- UTF-8 encoding safety
- Clean data ingestion

```bash
import.ipynb
```

### Step 3: Data Cleaning & Formatting (SQL)

After importing the raw data, cleaning and transformations were performed using SQL.
📁 File used:
sql/clean.sql

- Actions performed:
- Removed invalid/null records
- Standardized text fields
- Fixed salary and numeric columns
- Prepared data for analytics

### Step 4

Once the data was clean, analytical queries were executed on the SQLite database:

- Funnel conversion analysis
- Cohort analysis
- Job success ranking
- City & skill demand analysis
- Time-to-hire metrics

### Step 5: View Results

Queries were executed using:

- SQLite Viewer in VS Code

---

📊 Sample Outputs

- Funnel Analysis

💡 Key Insights
- Significant drop-off between job views and applications
- Certain cities show consistently higher conversion rates
- Mid-level experience jobs attract the highest applications
- Some job postings receive high views but very low applies

🚀 Future Improvements
- Add Power BI / Tableau dashboar
- Automate data refresh
- Add salary normalization analysis

👤 Author
Parineeta Shinde
📍 Pune, India
🔗 GitHub
