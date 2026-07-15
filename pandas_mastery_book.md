
## Table of Contents
1. Series & DataFrame Fundamentals
2. Reading & Writing Data (CSV, Excel, SQL, JSON)
3. Selection & Indexing (loc, iloc, boolean masking, query)
4. Handling Missing Data
5. Sorting, Ranking, Deduplication
6. GroupBy — Split-Apply-Combine
7. Merging & Joining
8. Reshaping — pivot_table, melt, stack/unstack
9. String Operations (.str accessor)
10. Date/Time Handling
11. Apply / Map / Vectorization
12. Window & Rolling Functions
13. Categorical Dtype
14. MultiIndex
15. Performance Basics
16. Capstone — Real-World Messy Data Cleaning
17. Final Cheat Sheet

---

# Chapter 1: Series & DataFrame Fundamentals

## Why this matters on the job

Every pandas operation you'll ever write happens on top of these two structures. In Excel your mental model is "a sheet with rows and columns." In SQL it's "a table with a primary key." Pandas borrows from both but has its own quirk — the **index** — that trips up people coming from Excel/SQL backgrounds. Get this wrong early and every later chapter (groupby, merge, reshape) will feel confusing for the wrong reasons.

## Core theory

**Series** = a single labeled column. Think of it as one column from an Excel sheet, but every value also has a *label* (the index), not just a row number.

**DataFrame** = a dict of Series sharing the same index. Think "Excel sheet" or "SQL table" — but unlike SQL, a DataFrame has an explicit **index** that isn't just a row number, and unlike Excel, every column has a single dtype.

**The index is the concept that doesn't exist in Excel/SQL.** In SQL you have no built-in row identity beyond a primary key you define. In pandas, *every* DataFrame has an index whether you asked for one or not — by default it's `0, 1, 2, 3...` (like a SQL surrogate key), but you can set it to anything (a date, an employee ID, a composite key). This matters because:
- `loc` selects by index label, `iloc` selects by position — different things, easy to confuse (Chapter 3)
- merges can align on index
- "SettingWithCopyWarning" (Chapter 4 gotcha) is fundamentally an index/view confusion

**Dtypes** — you already know this from NumPy. Each column is really a NumPy (or Arrow-backed) array under the hood, so `int64`, `float64`, `object` (usually strings), `bool`, `datetime64[ns]`, `category` all apply. Mixed types in one column silently becomes `object`, which kills performance.

## Our running dataset

We'll use a small **retail sales** dataset — realistic enough to touch missing data, messy strings, dates, and groupings later. Type this yourself.

```python
import pandas as pd
import numpy as np

data = {
    'order_id':     [101, 102, 103, 104, 105, 106, 107, 108],
    'customer':     ['Amit Rao', 'Priya Shah', 'Amit Rao', 'Neha Joshi',
                      'Rahul Deshmukh', 'Priya Shah', 'Neha Joshi', 'Amit Rao'],
    'category':     ['Electronics', 'Grocery', 'Electronics', 'Apparel',
                      'Grocery', 'Apparel', 'Electronics', 'Grocery'],
    'product':      ['Headphones', 'Rice 5kg', 'Charger', 'T-Shirt',
                      'Atta 10kg', 'Jeans', 'Mouse', 'Milk 1L'],
    'quantity':     [1, 2, 1, 3, 1, 1, 2, np.nan],
    'unit_price':   [1499.0, 320.0, 599.0, 799.0, 450.0, 1299.0, 699.0, 60.0],
    'order_date':   ['2024-01-05', '2024-01-06', '2024-01-08', '2024-01-08',
                      '2024-01-10', '2024-01-12', '2024-01-15', '2024-01-15'],
    'city':         ['Pune', 'Mumbai', 'Pune', 'Nagpur',
                      'Pune', 'Mumbai', 'Nagpur', 'Pune']
}

df = pd.DataFrame(data)
df
```

Run that. You should see an 8-row table with a default `0-7` integer index on the left.

```python
# A DataFrame is a dict of Series
col = df['unit_price']
print(type(col))       # pandas.core.series.Series
print(col)              # notice the index prints alongside the values

# The index itself is a real object
print(df.index)         # RangeIndex(start=0, stop=8, step=1)
print(df.columns)       # the column labels

# Check dtypes -- do this reflexively, like checking column types in SQL DDL
print(df.dtypes)
```

Notice `quantity` is `float64`, not `int64` -- because of that one `NaN`. **A single missing value upgrades an entire integer column to float.**

Two ways to build a Series alone (useful for quick scratch work):

```python
s1 = pd.Series([10, 20, 30])                     # default index 0,1,2
s2 = pd.Series([10, 20, 30], index=['a','b','c']) # custom index -- like an ordered dict
s3 = pd.Series({'a': 10, 'b': 20, 'c': 30})       # from a dict -- keys become the index
```

## Common mistakes / gotchas

- **Assuming the index is just a row number.** After filtering, sorting, or setting a custom index, `df.index` can be anything, including duplicates. This is the #1 source of confusion once you hit `loc`.
- **Mixing types in a column without noticing.** One stray string in a numeric column (e.g. `"N/A"`) silently turns the whole column to `object`, breaking numeric ops downstream. Check `.dtypes` after loading real data -- treat it like checking a SQL schema.
- **Confusing `df.shape` (attribute, no parens) with a method call.** `.shape`, `.dtypes`, `.index`, `.columns` are cheap metadata attributes. `.info()`, `.describe()`, `.head()` ARE methods that do work.
- **NaN is always a float.** `np.nan` is `float('nan')` under the hood -- that's why it upgrades int columns to float. Pandas' nullable `Int64` dtype exists for true integer-with-missing, but it's opt-in, not default.

## My Turn

1. Print `df.dtypes`, `df.shape`, `df.columns`. In one sentence, explain why `quantity` isn't `int64`.
2. Build a Series called `prices` manually (not from `df`) for 4 fruits of your choice, with fruit names as the index. Retrieve one price using its label with `.loc[]`.
3. Run `df.info()`. Which column(s) have fewer than 8 non-null entries? Which `object` columns might secretly be numbers or dates stored as text (hint: `order_date`)?

## very important Questions

**Q1. "What's the difference between a Series and a DataFrame?"**
> A Series is a single one-dimensional labeled array -- basically one column with an index attached. A DataFrame is a collection of Series sharing the same index, so it behaves like a 2D table. Selecting one column with `df['col']` returns a Series; selecting multiple with `df[['col1','col2']]` returns a DataFrame.

**Q2. What does this output?**
```python
s = pd.Series([1, 2, np.nan, 4])
print(s.dtype)
```
> `float64`. `NaN` can only live in a float array under pandas' default dtypes, so the whole Series upcasts even though three values look like integers.

**Q3. "In a 10,000-row DataFrame, what's the default index, and what's the risk of relying on it?"**
> By default it's a `RangeIndex` -- 0 to 9999, basically a row number. It's not stable: filtering, sorting, or concatenating can leave gaps or duplicate labels, so `.iloc[5]` (position) and a label `5` can diverge unexpectedly. That's usually when people reach for `.reset_index()`.

**Q4. Spot the bug:**
```python
prices = pd.Series([100, 200, 300], index=['a', 'b', 'c'])
print(prices[1])
```
> This actually prints `200` -- but it's positional here only by coincidence. If the index itself contained integers (e.g. `index=[10,20,30]`), `prices[1]` would raise a KeyError instead of behaving positionally. This ambiguity is exactly why `.loc` and `.iloc` exist -- never rely on bare `[]` for anything but column selection on a DataFrame.


---

# Chapter 2: Reading & Writing Data (CSV, Excel, SQL, JSON)

## Why this matters on the job

Right now you probably open files by double-clicking them in Excel. As a pandas analyst, "opening a file" becomes one line of code -- and the *options* on that line (encoding, sheet name, dtype hints, date parsing) are what separate someone who can load a clean sample CSV from someone who can handle the messy exports your company's systems actually produce.

## Core theory

Pandas has a family of `read_*` functions and matching `to_*` functions. The mental model: **reading creates a DataFrame in memory; writing serializes it back out.** Nothing is saved to disk until you explicitly call a `to_*` method -- unlike Excel, where saving is implicit/manual via Ctrl+S but at least visible.

| Format | Read | Write | Excel/SQL equivalent |
|---|---|---|---|
| CSV | `pd.read_csv()` | `df.to_csv()` | Opening/saving a CSV in Excel |
| Excel | `pd.read_excel()` | `df.to_excel()` | Opening/saving an .xlsx |
| SQL | `pd.read_sql()` | `df.to_sql()` | `SELECT *` / `INSERT INTO` |
| JSON | `pd.read_json()` | `df.to_json()` | Nested key-value data, common in APIs |

## Runnable code

First, let's write our Chapter 1 dataset to disk so we have something realistic to re-read (this mimics "export from source system, re-import for analysis" which is most real DA work).

```python
import pandas as pd
import numpy as np

data = {
    'order_id':     [101, 102, 103, 104, 105, 106, 107, 108],
    'customer':     ['Amit Rao', 'Priya Shah', 'Amit Rao', 'Neha Joshi',
                      'Rahul Deshmukh', 'Priya Shah', 'Neha Joshi', 'Amit Rao'],
    'category':     ['Electronics', 'Grocery', 'Electronics', 'Apparel',
                      'Grocery', 'Apparel', 'Electronics', 'Grocery'],
    'product':      ['Headphones', 'Rice 5kg', 'Charger', 'T-Shirt',
                      'Atta 10kg', 'Jeans', 'Mouse', 'Milk 1L'],
    'quantity':     [1, 2, 1, 3, 1, 1, 2, np.nan],
    'unit_price':   [1499.0, 320.0, 599.0, 799.0, 450.0, 1299.0, 699.0, 60.0],
    'order_date':   ['2024-01-05', '2024-01-06', '2024-01-08', '2024-01-08',
                      '2024-01-10', '2024-01-12', '2024-01-15', '2024-01-15'],
    'city':         ['Pune', 'Mumbai', 'Pune', 'Nagpur',
                      'Pune', 'Mumbai', 'Nagpur', 'Pune']
}
df = pd.DataFrame(data)

# --- CSV ---
df.to_csv('sales.csv', index=False)          # index=False -- almost always what you want
df_csv = pd.read_csv('sales.csv')
df_csv.dtypes                                  # note: order_date comes back as object (string)!

# Re-read with date parsing done at load time
df_csv2 = pd.read_csv('sales.csv', parse_dates=['order_date'])
df_csv2.dtypes                                  # now datetime64[ns]

# --- Excel ---
df.to_excel('sales.xlsx', index=False, sheet_name='orders')
df_xl = pd.read_excel('sales.xlsx', sheet_name='orders')

# --- JSON ---
df.to_json('sales.json', orient='records', date_format='iso')
df_json = pd.read_json('sales.json')

# --- SQL (using an in-memory SQLite DB -- no server needed to practice) ---
import sqlite3
conn = sqlite3.connect(':memory:')
df.to_sql('orders', conn, index=False, if_exists='replace')

df_sql = pd.read_sql('SELECT * FROM orders WHERE category = "Electronics"', conn)
df_sql
```

Notice the SQL example: you can write a real `SELECT` string straight into `read_sql` -- this is your fastest bridge from existing SQL skill into pandas. Filtering can happen in the query itself (pushed to the DB) or in pandas after loading -- for large tables, filter in SQL; for small/local tables, either is fine.

## Common mistakes / gotchas

- **Forgetting `index=False` when writing CSV/Excel.** Without it, pandas writes the DataFrame's index as an extra unnamed column -- and when you re-read that file later, you get a stray `Unnamed: 0` column. This is the single most common "why is there a junk column" bug for beginners.
- **Dates don't round-trip automatically through CSV.** CSV has no native date type -- it's just text. You must explicitly `parse_dates=[...]` on read, every time, or dates silently become strings and date arithmetic (Chapter 10) will fail or misbehave.
- **`read_excel` needs `openpyxl` installed** (for `.xlsx`) -- if you get an `ImportError`, that's the fix, not a pandas bug.
- **`to_sql` with `if_exists='replace'` drops and recreates the table** -- fine for practice, dangerous on a real production table if you meant `'append'`.
- **Large CSVs loaded blindly.** `pd.read_csv('huge_file.csv')` on a multi-GB file will eat your RAM. Use `usecols=[...]` to load only needed columns, or `chunksize=` for streaming -- worth knowing exists even if you don't use it daily.

## My Turn

1. Write `df` to a CSV called `orders_export.csv` without the index column, then read it back and confirm `order_date` is `object` dtype until you explicitly parse it.
2. Write `df` to Excel, but only the `order_id`, `customer`, and `unit_price` columns (hint: select those columns before calling `.to_excel()`). Read it back and check `.shape`.
3. Using the SQLite connection above, write a `read_sql` query that returns only orders from `'Pune'` with `unit_price` over 500, using plain SQL syntax inside the string.

## very important Questions

**Q1. "How do you make sure a date column is actually usable as a date after reading a CSV?"**
> CSV has no date dtype -- everything comes in as text. I either pass `parse_dates=['col']` directly into `read_csv`, or convert after the fact with `pd.to_datetime(df['col'])`. I always check `.dtypes` right after loading to confirm it says `datetime64[ns]`, not `object`, before doing any date math.

**Q2. Spot the bug:**
```python
df.to_csv('out.csv')
df2 = pd.read_csv('out.csv')
print(df2.columns[0])
```
> Prints `'Unnamed: 0'`. Because `index=False` wasn't passed on write, the DataFrame's row index got saved as its own unlabeled column, and reading it back treats that as real data. Fix: `df.to_csv('out.csv', index=False)`.

**Q3. "When would you filter data in the SQL query passed to `read_sql` versus filtering in pandas after loading?"**
> If the source table is large, I push filtering, and ideally aggregation, into the SQL query itself so the database engine does the heavy lifting and only the smaller result set comes over the wire into memory. If the data's already small or I'm doing exploratory, iterative filtering, I'll just load it once and filter in pandas since re-running SQL queries for every tweak is slower to iterate on.

**Q4. "What's the difference between `to_sql(..., if_exists='replace')` and `if_exists='append')`?"**
> `'replace'` drops the existing table and recreates it from the DataFrame -- destructive, fine for a scratch/staging table. `'append'` inserts the DataFrame's rows into the existing table without touching what's already there. Using `'replace'` against a real production table by mistake is a classic "wiped my table" incident, so I'm always deliberate about which one I pass.


---

# Chapter 3: Selection & Indexing (loc, iloc, boolean masking, query)

## Why this matters on the job

This is the pandas equivalent of Excel's filter/AutoFilter and SQL's `WHERE` clause -- it's what you'll type more than anything else. Getting `loc` vs `iloc` confused is the #1 beginner mistake and the #1 source of `SettingWithCopyWarning` headaches later.

## Core theory

- **`df.loc[row_labels, col_labels]`** -- selects by **label** (index value, column name). Think `WHERE` + explicit column list in SQL.
- **`df.iloc[row_positions, col_positions]`** -- selects by **integer position**, like Excel's row/column numbers, completely ignoring labels.
- **Boolean masking** -- `df[df['col'] > x]` -- this IS your `WHERE` clause. A boolean Series the same length as `df` gets used to keep only `True` rows.
- **`.query()`** -- a string-based way to write the same filter, e.g. `df.query('unit_price > 500 and city == "Pune"')`. Reads closer to SQL, useful for complex conditions, but boolean masking is more common in real code and lets you use variables more naturally.

The critical distinction: `loc`'s slicing is **label-inclusive** on both ends (`df.loc[0:2]` includes row labeled `2`), while `iloc`'s slicing is **position-exclusive** like standard Python (`df.iloc[0:2]` stops before position 2). This is a very common "off by one" very important gotcha.

## Runnable code

```python
import pandas as pd
import numpy as np

data = {
    'order_id':     [101, 102, 103, 104, 105, 106, 107, 108],
    'customer':     ['Amit Rao', 'Priya Shah', 'Amit Rao', 'Neha Joshi',
                      'Rahul Deshmukh', 'Priya Shah', 'Neha Joshi', 'Amit Rao'],
    'category':     ['Electronics', 'Grocery', 'Electronics', 'Apparel',
                      'Grocery', 'Apparel', 'Electronics', 'Grocery'],
    'product':      ['Headphones', 'Rice 5kg', 'Charger', 'T-Shirt',
                      'Atta 10kg', 'Jeans', 'Mouse', 'Milk 1L'],
    'quantity':     [1, 2, 1, 3, 1, 1, 2, np.nan],
    'unit_price':   [1499.0, 320.0, 599.0, 799.0, 450.0, 1299.0, 699.0, 60.0],
    'order_date':   ['2024-01-05', '2024-01-06', '2024-01-08', '2024-01-08',
                      '2024-01-10', '2024-01-12', '2024-01-15', '2024-01-15'],
    'city':         ['Pune', 'Mumbai', 'Pune', 'Nagpur',
                      'Pune', 'Mumbai', 'Nagpur', 'Pune']
}
df = pd.DataFrame(data)

# --- loc: label-based ---
df.loc[0]                       # row labeled 0 (a Series)
df.loc[0:2]                     # rows labeled 0,1,2 -- INCLUSIVE of 2
df.loc[0:2, 'customer']         # same rows, just the customer column
df.loc[:, ['customer', 'city']] # all rows, two columns

# --- iloc: position-based ---
df.iloc[0]                      # first row by position
df.iloc[0:2]                    # positions 0,1 -- EXCLUDES position 2, like normal Python slicing
df.iloc[0:2, [1, 7]]            # positions, both rows and columns

# --- boolean masking (your WHERE clause) ---
mask = df['city'] == 'Pune'
df[mask]

df[(df['unit_price'] > 500) & (df['city'] == 'Pune')]   # AND -> use & with parentheses around each condition
df[(df['category'] == 'Grocery') | (df['category'] == 'Apparel')]  # OR -> use |

# --- .query() equivalent ---
df.query('unit_price > 500 and city == "Pune"')

min_price = 500
df.query('unit_price > @min_price')   # @ references a Python variable inside the query string

# --- loc with a boolean mask + column selection together (very common combo) ---
df.loc[df['unit_price'] > 500, ['customer', 'product', 'unit_price']]
```

## Common mistakes / gotchas

- **Using `and`/`or` instead of `&`/`|` in boolean masks.** Python's `and`/`or` don't work element-wise on Series -- you'll get a `ValueError: truth value of a Series is ambiguous`. Always use `&`, `|`, `~` (not), and wrap each condition in parentheses because of operator precedence.
- **Chained indexing** -- `df[df['city']=='Pune']['unit_price'] = 100` -- looks fine but triggers `SettingWithCopyWarning` because you're indexing twice, and pandas can't guarantee the first `[]` returned a view vs a copy. The fix is always a single `.loc[]` call: `df.loc[df['city']=='Pune', 'unit_price'] = 100`.
- **`loc` slicing is inclusive, `iloc` slicing is exclusive.** `df.loc[0:2]` gives 3 rows; `df.iloc[0:2]` gives 2 rows. This asymmetry trips up everyone at least once.
- **Forgetting `.copy()` when you intend to build a separate DataFrame.** `sub = df[df['city']=='Pune']` returns a view-or-copy ambiguously; if you're going to modify `sub`, write `sub = df[df['city']=='Pune'].copy()` explicitly to avoid the warning and any doubt about whether you're mutating the original.

## My Turn

1. Select all orders from `'Electronics'` category with `quantity` greater than 1, showing only `customer`, `product`, `quantity` columns -- using boolean masking with `.loc`.
2. Rewrite the same filter using `.query()`.
3. Using `iloc`, select the last 3 rows and the first 3 columns of `df` (hint: negative indices work with `iloc` just like plain Python lists).

## very important Questions

**Q1. "What's the core difference between `loc` and `iloc`?"**
> `loc` selects by label -- the actual index value or column name -- while `iloc` selects by integer position, ignoring what the labels are. If my DataFrame's index isn't the default `0,1,2...` -- say it's dates or customer IDs -- `loc[5]` would look for the label `5`, which might not even exist, whereas `iloc[5]` always means "the 6th row, whatever its label is."

**Q2. Spot the bug:**
```python
df[df['city'] == 'Pune']['unit_price'] = 999
```
> This raises `SettingWithCopyWarning` and may silently fail to update anything, because chaining two `[]` calls means pandas can't guarantee the first selection was a view into the original DataFrame rather than a copy -- so the assignment might be happening on a throwaway copy. The correct way is a single `.loc` call: `df.loc[df['city'] == 'Pune', 'unit_price'] = 999`.

**Q3. "How would you filter for rows where city is Pune OR Mumbai, and price is above 500?"**
> `df[((df['city']=='Pune') | (df['city']=='Mumbai')) & (df['unit_price']>500)]` -- or more idiomatically, `df[df['city'].isin(['Pune','Mumbai']) & (df['unit_price']>500)]`. I'd reach for `.isin()` over multiple `|` conditions whenever I'm checking membership in more than two values -- it's the pandas equivalent of SQL's `IN (...)`.

**Q4. "What does `df.loc[0:2]` return versus `df.iloc[0:2]`, assuming a default RangeIndex?"**
> `df.loc[0:2]` returns 3 rows (labels 0, 1, and 2 -- loc slicing is inclusive on the endpoint). `df.iloc[0:2]` returns 2 rows (positions 0 and 1 -- iloc slicing follows normal Python exclusive-end convention). It's a classic off-by-one trap if you don't know this distinction going in.


---

# Chapter 4: Handling Missing Data

## Why this matters on the job

Real data is never as clean as our sample `df`. Excel hides blank cells; SQL has `NULL` with three-valued logic; pandas has `NaN`/`NaT`/`None` and very explicit tools for finding, dropping, or filling them. Getting missing-data handling wrong quietly corrupts every downstream aggregation, and it's one of the most common places DA very importanters probe for judgement, not just syntax.

## Core theory

- **`isna()` / `notna()`** -- detect missing values, return a boolean mask. (`isnull()`/`notnull()` are aliases, identical behavior.)
- **`dropna()`** -- remove rows (or columns) containing missing values.
- **`fillna()`** -- replace missing values with something: a constant, a computed statistic, or a forward/backward fill.

The judgement call very importanters actually care about: **when is each the right choice?**
- Drop when missingness is rare and rows are still representative without it (e.g. <1% of rows, no obvious pattern).
- Fill with a constant/statistic when the missing value has a sensible default (e.g. missing `quantity` might reasonably default to the median or mode order size).
- Fill with forward/backward fill only for genuinely sequential data (e.g. a stock price or sensor reading that "carries forward" between readings) -- doing this on non-sequential categorical data is usually wrong.
- Sometimes the *right* answer is "don't guess -- flag it and go ask the data owner." Say this in very importants; it shows judgement over rote syntax.

## Runnable code

```python
import pandas as pd
import numpy as np

data = {
    'order_id':     [101, 102, 103, 104, 105, 106, 107, 108],
    'customer':     ['Amit Rao', 'Priya Shah', 'Amit Rao', 'Neha Joshi',
                      'Rahul Deshmukh', 'Priya Shah', 'Neha Joshi', 'Amit Rao'],
    'category':     ['Electronics', 'Grocery', 'Electronics', 'Apparel',
                      'Grocery', 'Apparel', 'Electronics', 'Grocery'],
    'product':      ['Headphones', 'Rice 5kg', 'Charger', 'T-Shirt',
                      'Atta 10kg', 'Jeans', 'Mouse', 'Milk 1L'],
    'quantity':     [1, 2, 1, 3, 1, 1, 2, np.nan],
    'unit_price':   [1499.0, 320.0, 599.0, 799.0, 450.0, 1299.0, 699.0, 60.0],
    'order_date':   ['2024-01-05', '2024-01-06', '2024-01-08', '2024-01-08',
                      '2024-01-10', '2024-01-12', '2024-01-15', '2024-01-15'],
    'city':         ['Pune', 'Mumbai', 'Pune', 'Nagpur',
                      'Pune', 'Mumbai', 'Nagpur', 'Pune']
}
df = pd.DataFrame(data)

# Detect
df.isna()                    # full boolean grid
df.isna().sum()              # count of missing values per column -- the first thing to run on any new dataset
df[df['quantity'].isna()]    # which rows have the missing quantity?

# Drop
df.dropna()                                # drops any row with ANY missing value
df.dropna(subset=['quantity'])             # only consider this column when deciding to drop
df.dropna(axis=1)                          # drop COLUMNS that have any missing value instead of rows
df.dropna(thresh=7)                        # keep rows with at least 7 non-null values

# Fill
df['quantity'].fillna(1)                                  # constant
df['quantity'].fillna(df['quantity'].median())             # statistic -- often the safer default
df['quantity'].fillna(df.groupby('category')['quantity'].transform('median'))  # smarter: fill using the group's median (preview of Chapter 6)

# ffill / bfill -- only sensible for ordered/sequential data
df_sorted = df.sort_values('order_date')
df_sorted['quantity'].ffill()   # carries the last valid value forward
df_sorted['quantity'].bfill()   # carries the next valid value backward

# fillna is NOT in-place by default -- must reassign or use inplace=True
df['quantity'] = df['quantity'].fillna(df['quantity'].median())
```

## Common mistakes / gotchas

- **`fillna()` / `dropna()` return a NEW object by default** -- forgetting to reassign (`df = df.dropna()`) means your "cleaning" did nothing to the variable you keep using. `inplace=True` exists but is increasingly discouraged (it silently breaks method chaining and can produce its own copy-warnings) -- prefer reassignment.
- **Blindly filling with 0 or the mean without thinking about what missing *means*.** A missing `quantity` might mean "data entry forgot to type it" (fill with typical value) or might mean "this was a free promotional item, so 0 is actually correct" (don't fill with the mean!). Always ask what NaN represents before choosing how to handle it -- very importanters listen for this reasoning.
- **`dropna()` with no `subset` drops on ANY column having a null**, which can silently wipe out far more rows than intended in a wide DataFrame. Always specify `subset=[...]` in real work.
- **Comparing to NaN with `==` never works** -- `df['quantity'] == np.nan` returns all `False`, because NaN isn't equal to anything, including itself. Always use `.isna()`.
- **`NaT`** is the missing-value marker for datetime columns (not NaN, though it behaves similarly) -- worth recognizing in `.info()` output so you're not confused by a different-looking null.

## My Turn

1. Count how many missing values exist in each column of `df`. Then create `df_clean` by filling `quantity`'s missing value with the **median quantity per category** (like the groupby example above), and confirm with `.isna().sum()` that it's now 0.
2. Create a copy of `df` with an extra row where `unit_price` is also missing (`np.nan`). Try `dropna(subset=['quantity','unit_price'])` and explain in one sentence why the row count differs from a plain `dropna()`.
3. Sort by `order_date` and demonstrate the difference between `.ffill()` and `.bfill()` on the `quantity` column -- print both results side by side and note where they'd disagree if there were two consecutive missing values.

## very important Questions

**Q1. "Someone asks you to handle missing values in a revenue column -- what do you actually consider before writing code?"**
> First I check how much is missing and whether it's random or has a pattern -- e.g. all missing rows might belong to one region or one date range, which tells a story on its own. Then I think about what "missing" plausibly means for this field: a genuine data entry gap I should impute, versus a legitimate zero that got recorded as blank. Only after that do I decide between dropping, filling with a statistic, or flagging it for the data owner -- I wouldn't just reflexively drop rows or fill with the mean without that context.

**Q2. What does this output?**
```python
s = pd.Series([1, np.nan, 3])
print(s == np.nan)
```
> `[False, False, False]`. NaN is never equal to anything, even another NaN, by IEEE floating-point definition, so a direct `==` comparison always returns `False`. You have to use `.isna()` to actually detect it.

**Q3. "What's the difference between `dropna()` and `dropna(subset=['col'])`?"**
> Plain `dropna()` drops a row if ANY column in that row has a missing value, which on a wide table can be far too aggressive. `dropna(subset=['col'])` only checks the specified column(s) when deciding whether to drop the row, ignoring nulls elsewhere. In real work I almost always specify a subset -- I want to control exactly which field's missingness matters for that decision.

**Q4. "When would forward-fill be the wrong choice?"**
> Forward-fill assumes the previous value is still valid until a new one appears, which only makes sense for genuinely sequential/time-ordered data like a stock price or a sensor reading. If I forward-filled a `customer_name` or `category` column in a transactional table, I'd just be propagating whatever the last row happened to have, which has no logical relationship to the current row -- that's a fabrication, not an imputation.

---

# Chapter 5: Sorting, Ranking, Deduplication

## Why this matters on the job

This is your Excel "Sort & Filter" button and SQL's `ORDER BY` / `ROW_NUMBER()` / `DISTINCT`, but with more control -- multi-column sorts with mixed directions, ranking with tie-breaking rules, and dedup logic based on specific columns rather than whole rows.

## Core theory

- **`sort_values()`** -- sort by one or more columns, ascending or descending. Equivalent to SQL `ORDER BY col1, col2 DESC`.
- **`sort_index()`** -- sort by the index itself rather than column values.
- **`rank()`** -- assign ranks, with configurable tie-breaking (`method='min'`, `'dense'`, `'first'`, etc.) -- equivalent to SQL's `RANK()`, `DENSE_RANK()`, `ROW_NUMBER()` window functions.
- **`drop_duplicates()`** -- remove duplicate rows, optionally based on a subset of columns -- equivalent to SQL `DISTINCT`, but with more control over *which* duplicate to keep (`keep='first'`, `'last'`, `False`).
- **`duplicated()`** -- returns a boolean mask flagging duplicates, useful for *inspecting* dupes before deciding how to handle them (never blindly drop without looking first).

## Runnable code

```python
import pandas as pd
import numpy as np

data = {
    'order_id':     [101, 102, 103, 104, 105, 106, 107, 108],
    'customer':     ['Amit Rao', 'Priya Shah', 'Amit Rao', 'Neha Joshi',
                      'Rahul Deshmukh', 'Priya Shah', 'Neha Joshi', 'Amit Rao'],
    'category':     ['Electronics', 'Grocery', 'Electronics', 'Apparel',
                      'Grocery', 'Apparel', 'Electronics', 'Grocery'],
    'product':      ['Headphones', 'Rice 5kg', 'Charger', 'T-Shirt',
                      'Atta 10kg', 'Jeans', 'Mouse', 'Milk 1L'],
    'quantity':     [1, 2, 1, 3, 1, 1, 2, 1],
    'unit_price':   [1499.0, 320.0, 599.0, 799.0, 450.0, 1299.0, 699.0, 60.0],
    'order_date':   ['2024-01-05', '2024-01-06', '2024-01-08', '2024-01-08',
                      '2024-01-10', '2024-01-12', '2024-01-15', '2024-01-15'],
    'city':         ['Pune', 'Mumbai', 'Pune', 'Nagpur',
                      'Pune', 'Mumbai', 'Nagpur', 'Pune']
}
df = pd.DataFrame(data)

# --- Sorting ---
df.sort_values('unit_price')                              # ascending, default
df.sort_values('unit_price', ascending=False)              # descending
df.sort_values(['category', 'unit_price'], ascending=[True, False])  # multi-column, mixed direction -- like ORDER BY category ASC, unit_price DESC

df.sort_index()             # sort by the row index itself
df.sort_values('customer').reset_index(drop=True)   # sort + clean re-numbered index (drop=True discards the old one instead of adding it as a column)

# --- Ranking ---
df['price_rank'] = df['unit_price'].rank(ascending=False, method='min')
# method='min'   -> ties share the lowest rank, next rank skips  (like SQL RANK())
# method='dense' -> ties share the rank, next rank does NOT skip (like SQL DENSE_RANK())
# method='first' -> ties broken by order of appearance          (like SQL ROW_NUMBER())

df[['customer', 'unit_price', 'price_rank']].sort_values('price_rank')

# Rank WITHIN each group -- a very common very important ask (preview of groupby, Chapter 6)
df['rank_in_category'] = df.groupby('category')['unit_price'].rank(ascending=False, method='dense')

# --- Deduplication ---
df_dup = pd.concat([df, df.iloc[[0]]], ignore_index=True)  # manufacture a duplicate row for practice
df_dup.duplicated()                     # boolean mask, marks 2nd+ occurrence as True by default
df_dup.duplicated(keep=False)           # marks ALL occurrences of a dupe as True, useful to inspect both

df_dup.drop_duplicates()                                # drop full-row duplicates
df_dup.drop_duplicates(subset=['customer', 'order_date'])  # dedup based on specific columns only
df_dup.drop_duplicates(subset=['customer'], keep='last')   # keep the LAST occurrence per customer instead of the first
```

## Common mistakes / gotchas

- **Forgetting `.reset_index(drop=True)` after sorting**, leading to a confusing/jumbled index that then trips up `.iloc` later (positions no longer visually match labels).
- **Confusing `rank(method='min')` vs `method='dense')`** -- this is a frequent very important trap. `'min'` leaves gaps after ties (1,1,3,4...); `'dense'` doesn't (1,1,2,3...). Know both by name, not just "the rank function."
- **`drop_duplicates()` with no `subset` checks EVERY column** -- two rows that differ in even one column (like a timestamp) won't be flagged as duplicates even if they represent the same real-world event. Always think about which columns actually define "duplicate" for your business case.
- **Not inspecting duplicates before dropping them.** Running `drop_duplicates()` blind can silently discard legitimate repeat transactions (e.g. a customer genuinely buying the same product twice). Use `duplicated(keep=False)` first to eyeball what's being flagged.

## My Turn

1. Sort `df` by `category` ascending, then `unit_price` descending, within each category. Reset the index cleanly afterward.
2. Add a `rank_in_category` column ranking `unit_price` within each `category` using `method='dense'`, descending. Which category has a tie, and what ranks do the tied rows get?
3. Manufacture a duplicate customer order (same `customer` and `order_date`, different `order_id`) by concatenating a modified row onto `df`. Use `duplicated(keep=False)` to find it, then decide and justify which one you'd keep with `drop_duplicates()`.

## very important Questions

**Q1. "What's the difference between `rank(method='min')` and `rank(method='dense')`?"**
> Both give tied values the same rank, but `'min'` leaves a gap afterward equal to the number of tied rows -- so two rows tied for 1st means the next rank is 3. `'dense'` doesn't leave gaps -- the next rank is just 2. It's the same distinction as SQL's `RANK()` versus `DENSE_RANK()`, and I'd pick based on whether the business wants ranks to reflect "how many things beat me" (min/RANK) or just "which tier am I in" (dense/DENSE_RANK).

**Q2. "How do you remove duplicate customer orders, but only when both the customer and the date match?"**
> `df.drop_duplicates(subset=['customer', 'order_date'])`. I wouldn't drop based on the whole row, because two genuinely different orders could share every other column by coincidence, or differ only in a column I don't care about for this dedup logic, like a generated ID.

**Q3. Spot the bug:**
```python
df.sort_values('unit_price', ascending=False)
print(df.iloc[0])
```
> This prints the *original* first row, not the highest-priced one -- `sort_values()` returns a new sorted DataFrame by default rather than sorting in place, and since it wasn't reassigned, `df` itself is unchanged. Fix: `df = df.sort_values('unit_price', ascending=False)`.

**Q4. "How would you get the top 2 highest-priced products per category?"**
> `df.sort_values('unit_price', ascending=False).groupby('category').head(2)` -- sort globally first, then take the first 2 rows within each group, which after sorting are automatically the top 2 by price. Alternatively, rank within each group with `method='first'` and filter `rank <= 2`, which is closer to a SQL window-function mental model if that's more natural to explain out loud.


---

# Chapter 6: GroupBy — Split-Apply-Combine

## Why this matters on the job

This is the single most very important-tested pandas topic for DAs, and it's your pivot table, formalized. Every "total sales by region," "average order value by customer," "count of orders by category" task you've done by dragging fields into a Power BI/Excel pivot table is a `groupby()` call.

## Core theory

GroupBy follows **split -> apply -> combine**:
1. **Split** the DataFrame into groups based on one or more columns' values.
2. **Apply** a function to each group independently (sum, mean, count, or a custom function).
3. **Combine** the results back into a single DataFrame/Series.

Direct mental mapping to what you know:
- `df.groupby('category')['unit_price'].mean()` == pivot table with `category` in Rows, `unit_price` in Values (Average).
- `df.groupby('category').agg({'unit_price':'mean','quantity':'sum'})` == a pivot table with multiple Value fields, each with a different aggregation.
- SQL equivalent: `SELECT category, AVG(unit_price) FROM orders GROUP BY category`.

**`agg()` vs `transform()` vs `apply()` -- the part everyone gets fuzzy on:**
- **`agg()`** -- returns one row per group (a smaller, summarized DataFrame). Use when you want the summary itself.
- **`transform()`** -- returns a result the **same length as the original DataFrame**, with the group's aggregate value broadcast back to every row of that group. Use when you want to attach a group-level stat back onto each original row (e.g. "this order's price vs. its category's average price").
- **`apply()`** -- the most flexible/slowest: runs an arbitrary function per group, which can return a scalar, a Series, or a DataFrame. Use only when `agg`/`transform` genuinely can't express what you need -- it's a last resort, not a default habit, because it's slower and less predictable in shape.

## Runnable code

```python
import pandas as pd
import numpy as np

data = {
    'order_id':     [101, 102, 103, 104, 105, 106, 107, 108],
    'customer':     ['Amit Rao', 'Priya Shah', 'Amit Rao', 'Neha Joshi',
                      'Rahul Deshmukh', 'Priya Shah', 'Neha Joshi', 'Amit Rao'],
    'category':     ['Electronics', 'Grocery', 'Electronics', 'Apparel',
                      'Grocery', 'Apparel', 'Electronics', 'Grocery'],
    'product':      ['Headphones', 'Rice 5kg', 'Charger', 'T-Shirt',
                      'Atta 10kg', 'Jeans', 'Mouse', 'Milk 1L'],
    'quantity':     [1, 2, 1, 3, 1, 1, 2, 1],
    'unit_price':   [1499.0, 320.0, 599.0, 799.0, 450.0, 1299.0, 699.0, 60.0],
    'order_date':   ['2024-01-05', '2024-01-06', '2024-01-08', '2024-01-08',
                      '2024-01-10', '2024-01-12', '2024-01-15', '2024-01-15'],
    'city':         ['Pune', 'Mumbai', 'Pune', 'Nagpur',
                      'Pune', 'Mumbai', 'Nagpur', 'Pune']
}
df = pd.DataFrame(data)
df['revenue'] = df['quantity'] * df['unit_price']

# --- Basic aggregation ---
df.groupby('category')['revenue'].sum()          # Series: total revenue per category
df.groupby('category')['revenue'].mean()          # average
df.groupby('category').size()                      # row count per group (includes NaN rows)
df.groupby('category')['order_id'].count()          # count of non-null order_id per group -- subtly different from size() if nulls exist

# --- Group by multiple columns ---
df.groupby(['city', 'category'])['revenue'].sum()   # like a 2-level pivot table

# --- agg() with multiple aggregations at once ---
df.groupby('category').agg(
    total_revenue=('revenue', 'sum'),
    avg_price=('unit_price', 'mean'),
    orders=('order_id', 'count')
)   # named aggregation -- the modern, readable way. Output columns are exactly as named.

# --- transform(): broadcast group stat back onto every original row ---
df['category_avg_price'] = df.groupby('category')['unit_price'].transform('mean')
df['price_vs_category_avg'] = df['unit_price'] - df['category_avg_price']
df[['product','category','unit_price','category_avg_price','price_vs_category_avg']]

# --- apply(): custom logic per group (use sparingly) ---
def top_product_by_revenue(group):
    return group.loc[group['revenue'].idxmax(), 'product']

df.groupby('category').apply(top_product_by_revenue, include_groups=False)

# --- Iterating over groups directly (rarely needed, but good to recognize) ---
for name, group in df.groupby('category'):
    print(name, len(group))
```

## Common mistakes / gotchas

- **`size()` vs `count()`** -- `size()` counts rows per group including those with NaN in the column you'd otherwise count; `count()` counts non-null values in a specific column. They can give different numbers on the same data, and very importanters love asking why.
- **Forgetting `transform` must return something the same length as the input** -- if your custom function inside `transform` doesn't preserve the group's row count, you'll get a confusing error. `agg` doesn't have this restriction.
- **Reaching for `.apply()` by default** because it "always works" -- it's genuinely the slowest of the three for large data since it can't vectorize as well. Try `agg`/`transform` first; use `apply` only when the logic truly can't be expressed by them.
- **Multi-column groupby returns a MultiIndex** (Chapter 14) by default -- `df.groupby(['city','category'])['revenue'].sum()` gives you a Series with a two-level index, which surprises people expecting a flat table. `.reset_index()` flattens it back into normal columns.
- **`as_index=False`** -- pass this to `groupby()` to get a flat DataFrame with the group columns as regular columns instead of the index -- often cleaner for further processing: `df.groupby('category', as_index=False)['revenue'].sum()`.

## My Turn

1. Compute total `revenue` and average `quantity` per `city`, using named aggregation with `agg()`. Which city has the highest total revenue?
2. Add a column `pct_of_category_revenue` showing what percent each order's revenue is of its category's total revenue, using `transform('sum')`. (Hint: `row_revenue / category_total_revenue * 100`.)
3. For each `city`, find the single most expensive `product` sold there, using either `apply()` with `idxmax()`, or `sort_values` + `groupby().head(1)` as an alternative approach -- try both and see which reads more clearly to you.

## very important Questions

**Q1. "Walk me through what `groupby` actually does conceptually."**
> It's split-apply-combine: pandas splits the DataFrame into sub-groups based on the distinct values of the grouping column, applies whatever aggregation or function I specify to each group independently, then stitches the results back into a single output. It's the exact same mental model as a pivot table -- the grouping column becomes the pivot's row field, and the aggregation becomes the value field's summary function.

**Q2. "What's the difference between `agg()` and `transform()`?"**
> `agg()` collapses each group down to one summary row, so the output is smaller than the input -- good for a report-style summary. `transform()` keeps the original row count and broadcasts the group's aggregate value back onto every row belonging to that group -- good when I want to compare an individual row against its group's average, like flagging orders priced well above their category's mean.

**Q3. What does this output?**
```python
df = pd.DataFrame({'g': ['a','a','b'], 'v': [1, np.nan, 3]})
print(df.groupby('g').size())
print(df.groupby('g')['v'].count())
```
> `size()` gives `a: 2, b: 1` -- pure row counts per group regardless of nulls. `count()` on column `v` gives `a: 1, b: 1` -- because one of group `a`'s two rows has a NaN in `v`, and `count()` only counts non-null values. This mismatch is a classic sign someone actually understands groupby internals rather than just the syntax.

**Q4. "When would you avoid using `.apply()` on a groupby object?"**
> When the same result can be expressed with `agg()` or `transform()`, because `apply()` runs a Python-level function per group rather than using pandas' vectorized/optimized paths, so it's noticeably slower on large data and its output shape can be unpredictable depending on what the function returns. I'd reach for `apply()` only for genuinely custom multi-column logic that doesn't fit the built-in aggregation functions.

---

# Chapter 7: Merging & Joining

## Why this matters on the job

This is your SQL `JOIN`, and it's the operation that turns isolated tables (orders, customers, products) into the combined view an analysis actually needs. Real company data is almost always split across multiple tables/files, so this comes up constantly.

## Core theory

`pd.merge(left, right, on=..., how=...)` is pandas' JOIN. The `how` parameter maps directly onto SQL join types:

| pandas `how=` | SQL equivalent | Behavior |
|---|---|---|
| `'inner'` (default) | `INNER JOIN` | keep only rows with a match in both |
| `'left'` | `LEFT JOIN` | keep all left rows, match right where possible (NaN otherwise) |
| `'right'` | `RIGHT JOIN` | keep all right rows, match left where possible |
| `'outer'` | `FULL OUTER JOIN` | keep everything, match where possible |

`pd.concat()` is different — it's not a join at all, it's **stacking** DataFrames on top of each other (`axis=0`, like SQL `UNION ALL`) or side by side (`axis=1`, aligning on index).

## Runnable code

```python
import pandas as pd
import numpy as np

orders = pd.DataFrame({
    'order_id': [101, 102, 103, 104, 105],
    'customer_id': [1, 2, 1, 3, 99],   # note: customer_id 99 doesn't exist in customers table (a "bad" foreign key)
    'unit_price': [1499.0, 320.0, 599.0, 799.0, 450.0]
})

customers = pd.DataFrame({
    'customer_id': [1, 2, 3, 4],
    'customer_name': ['Amit Rao', 'Priya Shah', 'Neha Joshi', 'Rahul Deshmukh'],
    'city': ['Pune', 'Mumbai', 'Nagpur', 'Pune']
})

# --- INNER JOIN (default) -- only matching rows survive ---
pd.merge(orders, customers, on='customer_id', how='inner')
# order_id 105 (customer_id=99) disappears -- no match -- this is the #1 "why did my row count shrink" surprise

# --- LEFT JOIN -- keep every order, even ones with no matching customer ---
left = pd.merge(orders, customers, on='customer_id', how='left')
left   # order 105 stays, with NaN for customer_name and city

# --- RIGHT JOIN -- keep every customer, even ones with no orders ---
pd.merge(orders, customers, on='customer_id', how='right')
# customer_id=4 (Rahul) appears with NaN order fields -- he has no orders

# --- OUTER JOIN -- keep everything from both sides ---
pd.merge(orders, customers, on='customer_id', how='outer')

# --- Validating your join (CRITICAL habit for real work) ---
pd.merge(orders, customers, on='customer_id', how='left', validate='many_to_one', indicator=True)
# validate: raises an error if the join isn't actually many-to-one as you assumed -- catches silent row duplication
# indicator=True: adds a _merge column showing 'left_only' / 'right_only' / 'both' -- essential for auditing

# --- Different column names on each side ---
customers2 = customers.rename(columns={'customer_id': 'cust_id'})
pd.merge(orders, customers2, left_on='customer_id', right_on='cust_id', how='left')

# --- concat: stacking, not joining ---
more_orders = pd.DataFrame({'order_id':[106,107], 'customer_id':[2,3], 'unit_price':[699.0,60.0]})
pd.concat([orders, more_orders], ignore_index=True)   # stacks rows -- like SQL UNION ALL
```

## Common mistakes / gotchas

- **Assuming a merge preserves row count.** An inner join silently drops unmatched rows -- always compare `len(result)` to `len(left)`/`len(right)` after a merge you didn't fully expect the shape of.
- **Duplicate keys on one side silently fan out (Cartesian-like) rows.** If `customer_id` appears twice in the *right* table by accident (a data quality bug), a merge on it will duplicate every matching order row too -- this is exactly what `validate='many_to_one'` catches before it corrupts a downstream sum.
- **Forgetting `how=`, so you accidentally get inner join** when you actually needed to preserve unmatched rows (very common when checking for orphaned records, e.g. "orders with no matching customer" -- you need a `left` join plus a filter for NaN, not an inner join, to even see them).
- **Merging on columns with different dtypes** (e.g. `customer_id` as `int64` on one side and `object`/string on the other) silently produces zero matches, no error -- always check dtypes of join keys match before merging.
- **Not using `indicator=True` when debugging an unexpected merge result** — it's the fastest way to see exactly which rows failed to match and from which side.

## My Turn

1. Perform a left join of `orders` onto `customers` (i.e., keep every customer, even those with zero orders) and confirm which customer(s) show `NaN` order fields.
2. Find all orders with no matching customer record — the "orphaned" rows — using a left join plus a filter for missing `customer_name`. How many are there?
3. Deliberately add a duplicate `customer_id` row to the `customers` table (same id, different name — simulating a data quality bug), merge with `orders`, and observe what happens to the order row count. Then redo the merge with `validate='many_to_one'` and confirm it raises an error catching the problem.

## very important Questions

**Q1. "What's the difference between an inner join and a left join, and when would you use each?"**
> Inner join keeps only rows with a match on both sides, so if a foreign key doesn't resolve, that row disappears entirely. Left join keeps every row from the left table regardless of a match, filling unmatched right-side columns with NaN. I'd use inner when I only care about complete, matched records — say, revenue by verified customer — and left when I need to audit for gaps, like finding orders that reference a customer who doesn't exist in the master table.

**Q2. Spot the bug:**
```python
result = pd.merge(orders, customers, on='customer_id')
print(len(result), len(orders))
```
> If these two numbers differ, it's a sign the merge either dropped unmatched rows (default inner join — `len(result) < len(orders)` when some `customer_id`s don't exist in `customers`) or duplicated rows because of a repeated key on the right side (`len(result) > len(orders)`). Either way, I wouldn't ship a merge result without this sanity check.

**Q3. "How do you check whether your merge behaved the way you expected?"**
> Two habits: pass `indicator=True` to get a `_merge` column showing exactly which rows matched from `both`, `left_only`, or `right_only`; and pass `validate=` with the relationship I believe holds (`'one_to_one'`, `'one_to_many'`, `'many_to_one'`) so pandas raises an error immediately if a duplicate key silently violates that assumption, rather than letting a corrupted row count flow downstream into a wrong revenue number.

**Q4. "What's the difference between `merge` and `concat`?"**
> `merge` combines two tables side-by-side based on matching key values, like a SQL JOIN — it aligns rows by content. `concat` just stacks DataFrames on top of each other (or side by side by index) without any key-matching logic at all — it's closer to SQL's `UNION ALL`. I'd use `concat` to append new rows of the same shape (e.g. combining monthly export files) and `merge` to bring in related columns from a different table.


---

# Chapter 8: Reshaping — pivot_table, melt, stack/unstack

## Why this matters on the job

This is the chapter that trips up Excel-background analysts most, because Excel hides the wide-vs-long distinction behind a drag-and-drop pivot table UI, while pandas makes you think about it explicitly. Getting fluent here is what lets you go from "I can make one specific pivot table" to "I understand exactly what shape my data needs to be in for any downstream tool (charting, modeling, another pivot)."

## Core theory

**Wide format**: one row per entity, with different categories spread across separate *columns* (e.g. one row per customer, with a column per month: `Jan`, `Feb`, `Mar`). This is what a finished Excel pivot table looks like, and what's easiest for a human to read.

**Long format** (a.k.a. "tidy" format): one row per observation, with a `variable` column and a `value` column (e.g. `customer, month, revenue` — three rows per customer instead of one wide row). This is what most analysis tools, groupby, and plotting libraries actually want as input.

**The core skill is converting between the two:**
- **`pivot_table()`** — long -> wide. Like building an Excel pivot table: choose an index (rows), columns (spread across), values (what fills the cells), and an aggregation function. Directly analogous to Excel's PivotTable field list (Rows / Columns / Values / ∑ Values aggregation).
- **`melt()`** — wide -> long. The reverse: take spread-out columns and stack them into `variable`/`value` pairs. This is the one that has no direct Excel equivalent and initially feels backwards — but you'll need it constantly to get messy wide exports into a shape groupby/plotting can use.
- **`stack()` / `unstack()`** — lower-level versions of the same wide<->long conversion, but operating on MultiIndex levels (Chapter 14) rather than named columns. `pivot_table`/`melt` are usually what you reach for in practice; `stack`/`unstack` show up when you're already deep in MultiIndex territory.

## Runnable code

```python
import pandas as pd
import numpy as np

data = {
    'order_id':     [101, 102, 103, 104, 105, 106, 107, 108],
    'customer':     ['Amit Rao', 'Priya Shah', 'Amit Rao', 'Neha Joshi',
                      'Rahul Deshmukh', 'Priya Shah', 'Neha Joshi', 'Amit Rao'],
    'category':     ['Electronics', 'Grocery', 'Electronics', 'Apparel',
                      'Grocery', 'Apparel', 'Electronics', 'Grocery'],
    'product':      ['Headphones', 'Rice 5kg', 'Charger', 'T-Shirt',
                      'Atta 10kg', 'Jeans', 'Mouse', 'Milk 1L'],
    'quantity':     [1, 2, 1, 3, 1, 1, 2, 1],
    'unit_price':   [1499.0, 320.0, 599.0, 799.0, 450.0, 1299.0, 699.0, 60.0],
    'order_date':   ['2024-01-05', '2024-01-06', '2024-01-08', '2024-01-08',
                      '2024-01-10', '2024-01-12', '2024-01-15', '2024-01-15'],
    'city':         ['Pune', 'Mumbai', 'Pune', 'Nagpur',
                      'Pune', 'Mumbai', 'Nagpur', 'Pune']
}
df = pd.DataFrame(data)
df['revenue'] = df['quantity'] * df['unit_price']

# --- pivot_table: long -> wide (the Excel pivot table you already know) ---
pd.pivot_table(
    df,
    index='city',            # rows
    columns='category',      # spread across columns
    values='revenue',        # what fills the cells
    aggfunc='sum',           # how to summarize (sum, mean, count...)
    fill_value=0              # replace resulting NaN (no orders of that category in that city) with 0
)

# Multiple value fields at once -- like adding two fields to the Values area in Excel
pd.pivot_table(df, index='city', columns='category', values=['revenue','quantity'], aggfunc='sum', fill_value=0)

# --- melt: wide -> long (the one with no Excel equivalent) ---
wide = pd.pivot_table(df, index='city', columns='category', values='revenue', aggfunc='sum', fill_value=0).reset_index()
wide
# wide now has columns: city, Apparel, Electronics, Grocery -- one row per city

long_again = wide.melt(id_vars='city', var_name='category', value_name='revenue')
long_again
# back to long format: city, category, revenue -- one row per (city, category) combination
# this is the format groupby(), plotting libraries, and most ML libraries actually expect

# --- stack/unstack (MultiIndex-based reshaping -- preview, more in Chapter 14) ---
grouped = df.groupby(['city', 'category'])['revenue'].sum()   # this has a MultiIndex (city, category)
grouped.unstack()    # pivots the INNER index level (category) into columns -- same end result as pivot_table above
grouped.unstack().stack()   # stack reverses it -- columns become the inner index level again
```

## Common mistakes / gotchas

- **Not fixing NaN after `pivot_table`.** If a city had zero orders in a category, that cell is `NaN` by default — usually you want `fill_value=0` so downstream sums/charts aren't broken by missing cells.
- **Forgetting `.reset_index()` after `pivot_table`** when you want the row-grouping field (`city` here) back as a normal column instead of the index — needed before you can `melt()` it, for example.
- **Choosing the wrong `aggfunc`.** `pivot_table`'s default `aggfunc` is `'mean'`, not `'sum'` — a very common silent-wrong-number bug if you assumed it summed like a typical Excel pivot table default.
- **Reaching for `melt` and blanking on `id_vars` vs `value_vars`.** `id_vars` are the columns to KEEP as identifiers (not melted); everything else becomes `variable`/`value` pairs unless you explicitly restrict with `value_vars`.
- **Confusing which axis `stack`/`unstack` operate on.** `unstack()` moves the *innermost row index level* into columns; `stack()` moves the *innermost column level* into the row index. If you have a multi-level structure, always print `.index`/`.columns` before and after to confirm you moved the level you meant to.

## My Turn

1. Build a pivot table showing total `quantity` (not revenue) by `customer` (rows) and `category` (columns), with zero-filled gaps.
2. Take that pivot table, reset its index, and `melt()` it back into long format with columns `customer`, `category`, `quantity`. Confirm the total sum of `quantity` matches before and after (a good sanity check for any reshape).
3. Using `groupby(['category','city'])['revenue'].sum()`, produce a MultiIndex Series, then use `.unstack()` to pivot `city` into columns. Compare the result to doing the same thing directly with `pivot_table(index='category', columns='city', values='revenue', aggfunc='sum')` — confirm they match.

## very important Questions

**Q1. "What's the difference between wide and long format, and why does it matter?"**
> Wide format spreads categories across separate columns — easy for a human to scan, like a finished report. Long format has one row per individual observation with a variable/value pair — harder to eyeball, but it's what groupby, most plotting libraries, and machine learning inputs actually expect, because each row is a single atomic fact. Most of my reshaping work is converting messy wide exports into long format before I can actually analyze them, then pivoting back to wide only for the final presentation layer.

**Q2. "How would you turn a long table of (customer, month, revenue) rows into a wide table with one row per customer and a column per month?"**
> `df.pivot_table(index='customer', columns='month', values='revenue', aggfunc='sum', fill_value=0)`. I'd make sure to set `fill_value=0` since a customer with no transactions in a given month would otherwise show NaN instead of a clean zero.

**Q3. Spot the bug:**
```python
result = df.pivot_table(index='city', columns='category', values='revenue')
print(result.loc['Pune', 'Electronics'])
```
> If the values look off — e.g. lower than expected — it's likely because `pivot_table`'s default `aggfunc` is `'mean'`, not `'sum'`. If the intent was total revenue, this silently computes an average per (city, category) combination instead. Always pass `aggfunc='sum'` explicitly rather than relying on the default.

**Q4. "What does `melt()` actually do, in your own words?"**
> It converts wide columns into row values. I tell it which columns to keep as-is (`id_vars`) — usually an identifier like customer or city — and it takes all the remaining columns, turns each column *name* into a value in a new `variable` column, and each cell's original value into a matching `value` column. So a table with columns `city, Jan, Feb, Mar` becomes a table with columns `city, variable, value`, three rows per city instead of one.


---

# Chapter 9: String Operations (.str accessor)

## Why this matters on the job

Real-world text data is messy: inconsistent casing, stray whitespace, mixed formats, embedded info you need to extract. In Excel this is `TRIM`, `LEFT`/`RIGHT`/`MID`, `SUBSTITUTE`, text-to-columns. In pandas it's all under one consistent `.str` accessor on a Series.

## Core theory

Any Series with string data gets a `.str` accessor that vectorizes Python string methods across every row at once — instead of writing a loop and calling `.upper()` on each value individually, you call `.str.upper()` once on the whole column. The method names mostly mirror Python's built-in string methods, plus a few pandas-specific ones for extraction and matching.

| Task | pandas | Excel equivalent |
|---|---|---|
| Trim whitespace | `.str.strip()` | `TRIM()` |
| Change case | `.str.lower()`, `.str.upper()`, `.str.title()` | `LOWER`/`UPPER`/`PROPER` |
| Substring | `.str.slice()`, `.str[0:3]` | `LEFT`/`MID`/`RIGHT` |
| Find/replace | `.str.replace()` | `SUBSTITUTE` |
| Split into parts | `.str.split()` | `Text to Columns` |
| Contains a pattern | `.str.contains()` | `SEARCH`/wildcard `IF` |
| Extract with regex | `.str.extract()` | no clean equivalent — this is a pandas power move |

## Runnable code

```python
import pandas as pd

# Deliberately messy version of our customer names, to practice on
messy = pd.Series([' amit rao ', 'PRIYA SHAH', 'Neha  Joshi', 'rahul deshmukh', None])

# --- Cleaning basics ---
messy.str.strip()                 # removes leading/trailing whitespace
messy.str.lower()                 # 'amit rao', 'priya shah', ...
messy.str.title()                 # 'Amit Rao', 'Priya Shah', ...  -- good for standardizing names

clean = messy.str.strip().str.title()   # chain multiple string ops together, just like chaining Excel functions
clean

# --- Handling internal double-spaces (common copy-paste artifact) ---
clean.str.replace(r'\s+', ' ', regex=True)   # collapse any run of whitespace into a single space

# --- contains / startswith / endswith -- your SEARCH()/wildcard IF equivalent ---
clean.str.contains('Rao', na=False)          # na=False -- handle the None safely, avoid NaN propagating into the mask
clean.str.startswith('P', na=False)

# --- split -- Text to Columns equivalent ---
name_parts = clean.str.split(' ', expand=True)   # expand=True -> returns a DataFrame, one column per part
name_parts.columns = ['first_name', 'last_name']
name_parts

# --- extract -- regex-based extraction, no Excel equivalent this clean ---
products = pd.Series(['Rice 5kg', 'Atta 10kg', 'Headphones', 'Milk 1L'])
products.str.extract(r'(\d+)(kg|L)?')   # pulls out the numeric quantity and unit as separate columns

# --- len, slicing ---
clean.str.len()          # length of each string -- useful for spotting truncated/weird entries
clean.str[0:3]            # first 3 characters, like Excel's LEFT(cell, 3)

# --- Applying string ops to a real column in our dataset ---
data = {'product': ['Headphones', 'rice 5kg', 'CHARGER', 'T-Shirt  ', 'atta 10kg', 'Jeans', 'MOUSE', 'milk 1l']}
df = pd.DataFrame(data)
df['product_clean'] = df['product'].str.strip().str.title()
df
```

## Common mistakes / gotchas

- **Forgetting `na=False` in `.str.contains()`** when the Series has missing values — `contains()` returns `NaN` for those rows by default, which then breaks boolean masking (`df[mask]`) with a confusing error, since a mask can't contain NaN.
- **Not chaining `.str.strip()` before comparing/deduping text**, so `'Pune'` and `'Pune '` (trailing space) are treated as different values in a `groupby` or `drop_duplicates` — an extremely common source of "why do I have two rows for the same city" bugs.
- **Case-sensitivity surprises.** `'Pune' != 'pune'` — always `.str.lower()` (or `.title()` for consistent display) before grouping/joining on free-text fields unless you're certain the casing is already standardized.
- **Regex vs literal string confusion in `.str.replace()`.** By default in modern pandas, `.str.replace()` treats the pattern as a literal string unless you pass `regex=True` — mixing this up means special characters like `.` or `+` in your replacement pattern don't do what you expect.
- **`.str.split(expand=True)` can produce ragged results** (different numbers of parts per row) — extra columns get filled with `None` where a row didn't have that many parts. Always check `.shape` after, don't assume every row split cleanly.

## My Turn

1. Given `messy` above, produce a fully cleaned version: stripped, title-cased, with internal double-spaces collapsed to single spaces — in one chained expression.
2. From the `product` column in the sample `df` above, extract just the numeric quantity (e.g. `5`, `10`, or `NaN` for products with no embedded number) into a new column, using `.str.extract()` with a regex.
3. Using `.str.contains()`, find every product whose name contains a digit (hint: the regex `\d`), being careful to handle any missing values safely.

## very important Questions

**Q1. "How would you standardize a customer name column that has inconsistent casing and stray whitespace?"**
> I'd chain `.str.strip()` to remove leading/trailing whitespace and `.str.title()` to standardize casing, and if there's a risk of double spaces inside the name from copy-paste artifacts, I'd also run a regex replace collapsing repeated whitespace into one space before finalizing. I'd do this before any groupby or join on that column, since even a single trailing space makes pandas treat 'Pune' and 'Pune ' as two different groups.

**Q2. Spot the bug:**
```python
s = pd.Series(['apple', None, 'banana'])
mask = s.str.contains('a')
df[mask]
```
> This raises an error, because `s.str.contains('a')` returns `NaN` for the `None` entry, and a boolean mask containing `NaN` can't be used to index a DataFrame — pandas needs strictly `True`/`False`. Fix: `s.str.contains('a', na=False)`, which treats missing values as non-matches.

**Q3. "What's the pandas equivalent of Excel's Text to Columns feature?"**
> `.str.split(delimiter, expand=True)` — it splits each string in the Series on the given delimiter and, with `expand=True`, returns a full DataFrame with one column per resulting part instead of a Series of lists. I'd rename the resulting columns afterward since they come back as plain integer positions (0, 1, 2...).

**Q4. "How would you extract just the numeric part from strings like 'Rice 5kg' and 'Milk 1L'?"**
> `.str.extract(r'(\d+)')` — a regex capture group around one-or-more digits pulls out just the leading number as a new column, leaving the unit text behind. If I also needed the unit itself, I'd add a second capture group, e.g. `r'(\d+)(kg|L)'`, and `.str.extract()` returns each group as its own column.


---

# Chapter 10: Date/Time Handling

## Why this matters on the job

Almost every real analysis has a time dimension — daily sales, monthly trends, cohort ages, SLA breach durations. Excel dates are a single serial-number system that mostly "just works" until timezone or format issues appear; pandas gives you a dedicated `datetime64` dtype with rich, explicit tools that are far more powerful once you know them.

## Core theory

- **`pd.to_datetime()`** — the universal converter. Turns strings (or a mix of formats) into proper `datetime64[ns]` values. Do this immediately after loading any date column that came in as text (Chapter 2).
- **`.dt` accessor** — like `.str` for strings, `.dt` unlocks date components on a datetime Series: `.dt.year`, `.dt.month`, `.dt.day_name()`, `.dt.dayofweek`, etc.
- **Date arithmetic** — subtracting two datetime columns gives a `Timedelta`, from which you can extract `.dt.days`. Adding a fixed offset uses `pd.Timedelta` or `pd.DateOffset`.
- **`resample()`** — regroups a datetime-indexed Series/DataFrame into a different time frequency (daily -> monthly, etc.) with an aggregation, similar to `groupby` but specifically for time buckets. Requires a `DatetimeIndex`.

## Runnable code

```python
import pandas as pd
import numpy as np

data = {
    'order_id':     [101, 102, 103, 104, 105, 106, 107, 108],
    'customer':     ['Amit Rao', 'Priya Shah', 'Amit Rao', 'Neha Joshi',
                      'Rahul Deshmukh', 'Priya Shah', 'Neha Joshi', 'Amit Rao'],
    'category':     ['Electronics', 'Grocery', 'Electronics', 'Apparel',
                      'Grocery', 'Apparel', 'Electronics', 'Grocery'],
    'quantity':     [1, 2, 1, 3, 1, 1, 2, 1],
    'unit_price':   [1499.0, 320.0, 599.0, 799.0, 450.0, 1299.0, 699.0, 60.0],
    'order_date':   ['2024-01-05', '2024-01-06', '2024-01-08', '2024-01-08',
                      '2024-01-10', '2024-01-12', '2024-01-15', '2024-01-15'],
    'ship_date':    ['2024-01-07', '2024-01-09', '2024-01-08', '2024-01-11',
                      '2024-01-11', '2024-01-14', '2024-01-16', '2024-01-19'],
    'city':         ['Pune', 'Mumbai', 'Pune', 'Nagpur',
                      'Pune', 'Mumbai', 'Nagpur', 'Pune']
}
df = pd.DataFrame(data)
df['revenue'] = df['quantity'] * df['unit_price']

# --- Convert to real datetime ---
df['order_date'] = pd.to_datetime(df['order_date'])
df['ship_date'] = pd.to_datetime(df['ship_date'])
df.dtypes   # both now datetime64[ns]

# --- .dt accessor: pulling out components ---
df['order_date'].dt.year
df['order_date'].dt.month
df['order_date'].dt.day_name()      # 'Friday', 'Saturday', ...
df['order_date'].dt.dayofweek        # 0=Monday ... 6=Sunday
df['order_date'].dt.is_month_start   # boolean helper flags

df['order_weekday'] = df['order_date'].dt.day_name()

# --- Date arithmetic ---
df['days_to_ship'] = (df['ship_date'] - df['order_date']).dt.days   # Timedelta -> integer days
df[['customer','order_date','ship_date','days_to_ship']]

# Adding a fixed offset
df['order_date'] + pd.Timedelta(days=7)          # exactly 7*24 hours later
df['order_date'] + pd.DateOffset(months=1)        # calendar-aware: handles month-length differences correctly

# --- Filtering by date range (very common in real DA work) ---
df[(df['order_date'] >= '2024-01-08') & (df['order_date'] <= '2024-01-12')]

# --- resample: time-bucketed aggregation (needs a DatetimeIndex) ---
ts = df.set_index('order_date').sort_index()
ts['revenue'].resample('W').sum()     # weekly total revenue
ts['revenue'].resample('D').sum()     # daily total revenue (0 on days with no orders)

# --- Extracting a period label for grouping without a DatetimeIndex ---
df['order_month'] = df['order_date'].dt.to_period('M')
df.groupby('order_month')['revenue'].sum()
```

## Common mistakes / gotchas

- **Comparing a datetime column to a plain string works, but silently relies on pandas parsing that string correctly** — `df[df['order_date'] > '2024-01-08']` works fine for unambiguous ISO dates, but region-ambiguous formats (`'01/02/2024'` — Jan 2nd or Feb 1st?) can silently misparse. Prefer unambiguous `'YYYY-MM-DD'` strings or explicit `pd.Timestamp(...)`.
- **`resample()` requires a `DatetimeIndex`** — calling it on a DataFrame with a plain integer index and a datetime *column* raises an error. You must `set_index()` on the date column first.
- **Forgetting `.dt.days` after subtracting two datetime columns** — the raw result is a `Timedelta` object (e.g. `'2 days 00:00:00'`), which prints fine but won't behave like a plain number in further math or comparisons until you extract `.dt.days`.
- **`pd.to_datetime()` on a genuinely messy column with mixed formats** can raise a `ParserError` — the `format=` parameter lets you specify the exact expected format for speed and safety, and `errors='coerce'` turns unparseable values into `NaT` instead of crashing the whole operation (letting you find and fix them afterward, similar to how you'd handle other missing data).
- **Timezone-naive vs timezone-aware mismatches** — if you ever mix a naive datetime column with a tz-aware one (or compare against `pd.Timestamp.now()` which is naive by default), operations will raise. Not usually a day-one issue, but worth knowing the phrase for very importants.

## My Turn

1. Convert `order_date` and `ship_date` to real datetimes if not already, then compute `days_to_ship` for every order. Which order took the longest to ship?
2. Using `.dt.day_name()`, find out which day of the week has the most orders in this dataset.
3. Set `order_date` as the index, sort it, and use `.resample('W').sum()` on `revenue` to get weekly totals. Then do the same aggregation with `groupby(df['order_date'].dt.to_period('W'))` instead, and confirm the two approaches agree.

## very important Questions

**Q1. "You load a CSV and the date column looks fine when you print it, but date filtering doesn't work. What's likely wrong?"**
> Almost certainly the column is still `object` (string) dtype rather than `datetime64` — CSVs have no native date type, so pandas reads dates as plain text unless told otherwise. Printing a string that *looks* like a date doesn't mean it behaves like one for comparisons or arithmetic. I'd check `.dtypes` first, then fix it with `pd.to_datetime()` or `parse_dates=` at load time.

**Q2. "How would you calculate the number of days between an order date and a ship date?"**
> Subtract the two datetime columns directly — `df['ship_date'] - df['order_date']` — which produces a `Timedelta` Series, then call `.dt.days` on that to get a plain integer count of days I can aggregate or filter on normally.

**Q3. "What's the difference between `pd.Timedelta(days=30)` and `pd.DateOffset(months=1)` when adding to a date?"**
> `Timedelta` is a fixed physical duration — adding `Timedelta(days=30)` always adds exactly 30*24 hours, regardless of which month it lands in. `DateOffset(months=1)` is calendar-aware — it moves to the same day next month, correctly handling that months have different lengths (e.g. Jan 31 + 1 month lands on Feb 28/29, not 31 days later). I'd use `DateOffset` for anything conceptually "next month" and `Timedelta` for anything that's a genuine fixed-length duration.

**Q4. "How do you get weekly or monthly totals from daily transaction data?"**
> If the date column is the DataFrame's index, `df['revenue'].resample('W').sum()` (or `'M'` for monthly) buckets the data into those time windows and aggregates automatically, even filling in periods with zero activity. If I don't want to reindex, an equivalent is grouping by `df['order_date'].dt.to_period('W')`, which achieves the same bucketing via groupby instead of resample — useful when I want to combine it with other non-date grouping columns in the same call.


---

# Chapter 11: Apply / Map / Vectorization

## Why this matters on the job

This is where your NumPy vectorization knowledge pays off directly. The single biggest performance mistake new pandas users make is looping row-by-row (or reaching for `.apply()` reflexively) when a vectorized operation would be 10-100x faster and more idiomatic. very importanters specifically probe this because it reveals whether you understand *why* pandas is fast, not just its syntax.

## Core theory

Three tiers, roughly fastest to slowest:

1. **Vectorized operations** (fastest) — operate on entire columns at once using pandas/NumPy's compiled C code under the hood: `df['revenue'] = df['quantity'] * df['unit_price']`, `np.where(condition, a, b)`, boolean masking. Always your first choice.
2. **`.map()`** (Series only) — element-wise substitution, typically via a dict or a simple function. Good for lookups/recoding a single column.
3. **`.apply()`** (Series or DataFrame) — runs an arbitrary Python function per element (Series) or per row/column (DataFrame). Most flexible, but falls back to Python-level looping internally — genuinely slower at scale. Use only when the logic can't be vectorized.

**Why vectorized is faster (tying back to NumPy):** vectorized pandas/NumPy operations execute in compiled C loops under the hood, operating on contiguous memory in bulk. `.apply()`, by contrast, calls a Python function once per row/element — Python function call overhead multiplied by row count adds up fast. You already know this instinctively from NumPy array math (`arr * 2` vs. looping `for x in arr`) — the same principle carries over 1:1.

## Runnable code

```python
import pandas as pd
import numpy as np

data = {
    'order_id':     [101, 102, 103, 104, 105, 106, 107, 108],
    'category':     ['Electronics', 'Grocery', 'Electronics', 'Apparel',
                      'Grocery', 'Apparel', 'Electronics', 'Grocery'],
    'quantity':     [1, 2, 1, 3, 1, 1, 2, 1],
    'unit_price':   [1499.0, 320.0, 599.0, 799.0, 450.0, 1299.0, 699.0, 60.0],
    'city':         ['Pune', 'Mumbai', 'Pune', 'Nagpur',
                      'Pune', 'Mumbai', 'Nagpur', 'Pune']
}
df = pd.DataFrame(data)

# --- Vectorized: always your first instinct ---
df['revenue'] = df['quantity'] * df['unit_price']                 # simple arithmetic
df['high_value'] = df['revenue'] > 1000                            # boolean vectorized comparison

# np.where -- vectorized if/else, replaces a whole class of .apply() usage
df['price_tier'] = np.where(df['unit_price'] > 700, 'Premium', 'Standard')

# np.select -- vectorized if/elif/elif/else for multiple conditions
conditions = [
    df['unit_price'] > 1000,
    df['unit_price'] > 500,
]
choices = ['Premium', 'Mid']
df['price_tier2'] = np.select(conditions, choices, default='Budget')

# --- .map(): element-wise substitution on a Series, typically via a dict ---
city_region = {'Pune': 'West', 'Mumbai': 'West', 'Nagpur': 'Central'}
df['region'] = df['city'].map(city_region)   # a clean, vectorized-feeling lookup -- fast and idiomatic

# --- .apply() on a Series: only when logic can't be vectorized ---
def price_label(price):
    if price > 1000:
        return 'Premium'
    elif price > 500:
        return 'Mid'
    return 'Budget'

df['price_tier3'] = df['unit_price'].apply(price_label)   # works, but np.select above is faster for this exact case

# --- .apply() on a DataFrame (axis=1): row-wise, the slowest common pattern ---
def classify_order(row):
    if row['category'] == 'Electronics' and row['unit_price'] > 1000:
        return 'High-value Electronics'
    return 'Standard'

df['order_class'] = df.apply(classify_order, axis=1)   # axis=1 means "apply across each row"
# this is the pattern to use ONLY when logic genuinely needs multiple columns together
# and can't be expressed as a vectorized boolean combination
```

## Common mistakes / gotchas

- **Reaching for `df.apply(func, axis=1)` as a default habit.** It's the slowest common pattern in this chapter — it calls your Python function once per row. Almost every `axis=1` apply with simple conditional logic can be rewritten with `np.where`/`np.select`/boolean masking, and should be for anything beyond small data.
- **Confusing `.map()` (Series-only) with `.apply()` (works on both Series and DataFrame)** — `.map()` doesn't exist on a DataFrame directly (that's `.applymap()`/`.map()` in newer pandas, element-wise across the whole grid, rarely needed).
- **Using `.map()` with a dict that doesn't cover every value** — unmapped values silently become `NaN`, which is easy to miss. Always check `.isna().sum()` after a `.map()` lookup to confirm nothing fell through.
- **Writing a Python for-loop over `df.iterrows()`** — this is even slower than `.apply()` and should essentially never appear in production pandas code; it's mentioned here only so you recognize it as an anti-pattern if you see it in someone else's code or an very important question asking you to "spot what's slow."
- **Not recognizing when vectorization is impossible** — some genuinely row-dependent, stateful logic (e.g. running totals depending on a mutable external state beyond what `cumsum`/`shift` can express) really does need `.apply()` or even a loop. Knowing the exception exists, and being able to justify why, is itself a sign of understanding rather than dogma.

## My Turn

1. Rewrite the `classify_order` function above (checking `category == 'Electronics' and unit_price > 1000`) as a single vectorized boolean expression using `np.where` instead of `df.apply(..., axis=1)`. Confirm the output matches.
2. Use `.map()` to create a `city_tier` column: Pune -> 'Tier 1', Mumbai -> 'Tier 1', Nagpur -> 'Tier 2'. Then deliberately leave one city out of the dict and observe what happens to that row.
3. Using `np.select`, build a 3-tier `quantity_tier` column: `quantity >= 3` -> `'Bulk'`, `quantity == 2` -> `'Multi'`, else `'Single'`.

## very important Questions

**Q1. "Why is `df.apply(func, axis=1)` generally discouraged for simple conditional logic?"**
> Because it calls the Python function once per row rather than operating on the whole column in one vectorized, compiled pass — the per-row Python function-call overhead adds up and can be an order of magnitude slower on large data. Almost anything that boils down to "if this condition, then that value" can be expressed with `np.where` or `np.select`, which run in vectorized C code instead of a Python-level loop.

**Q2. "What's the difference between `.map()` and `.apply()` on a Series?"**
> They can look similar for a simple function, but `.map()` is specifically for Series and shines with dict-based lookups/recoding — like translating city names to regions. `.apply()` is more general-purpose and works on both Series and DataFrames (including row-wise with `axis=1`), but it's not meaningfully faster than `.map()` for the simple element-wise case — I'd reach for `.map()` when I have a lookup table in mind, and `.apply()` when I need arbitrary function logic that doesn't reduce to a dict.

**Q3. Spot the bug:**
```python
region_map = {'Pune': 'West', 'Mumbai': 'West'}
df['region'] = df['city'].map(region_map)
print(df['region'].isna().sum())
```
> This will show a non-zero count if any city in `df['city']` isn't a key in `region_map` (e.g. `'Nagpur'` here) — `.map()` silently fills unmatched values with `NaN` rather than raising an error. Always check for this after a dict-based `.map()`, especially on real-world categorical data where you might not know every distinct value up front.

**Q4. "How would you create a column that's 'High' if price is above 1000, 'Medium' if 500-1000, else 'Low' — without using `.apply()`?"**
> `np.select([df['price']>1000, df['price']>=500], ['High','Medium'], default='Low')`. `np.select` evaluates the condition list in order, top to bottom, like an if/elif chain, and assigns the corresponding choice for the first condition that's true for each row — entirely vectorized, no Python-level looping.


---

# Chapter 12: Window & Rolling Functions

## Why this matters on the job

Trend questions — "what's the 7-day moving average," "how does this month compare to last month," "what's the running total this quarter" — come up constantly in DA very importants and real dashboards. These map to SQL window functions (`LAG`, `LEAD`, running `SUM() OVER`) you may already know from your 100+ SQL problems, which makes this chapter mostly translation rather than new concepts.

## Core theory

- **`rolling(window=n)`** — a moving window of a fixed number of rows, over which you compute an aggregate (mean, sum, std...). Equivalent to a moving average formula you'd build manually in Excel with a shifting `AVERAGE(OFFSET(...))`, or SQL's `AVG(x) OVER (ROWS BETWEEN n PRECEDING AND CURRENT ROW)`.
- **`expanding()`** — like `rolling`, but the window grows to include everything from the start up to the current row — this is your running/cumulative total or running average. Equivalent to SQL's `SUM(x) OVER (ORDER BY date ROWS UNBOUNDED PRECEDING)`.
- **`shift(n)`** — moves values down (or up, with negative `n`) by `n` rows, without any aggregation — this is exactly SQL's `LAG`/`LEAD`.
- **`diff(n)`** — the difference between the current value and the value `n` rows before it — commonly `current - previous`, useful for period-over-period change. It's shorthand for `series - series.shift(n)`.
- **`cumsum()`, `cumprod()`, `cummax()`, `cummin()`** — simple cumulative versions of common aggregates, faster and more readable than `expanding()` for the common cases.

**Critical prerequisite:** all of these are order-sensitive — always `sort_values()` by your time/sequence column first, or the "trend" you compute will be meaningless.

## Runnable code

```python
import pandas as pd
import numpy as np

dates = pd.date_range('2024-01-01', periods=14, freq='D')
np.random.seed(42)
ts = pd.DataFrame({
    'date': dates,
    'daily_revenue': np.random.randint(2000, 8000, size=14)
}).sort_values('date').reset_index(drop=True)

# --- rolling: moving average / moving sum ---
ts['rolling_3d_avg'] = ts['daily_revenue'].rolling(window=3).mean()
# first 2 rows are NaN -- not enough prior data yet to fill a 3-row window; this is expected, not a bug

ts['rolling_3d_sum'] = ts['daily_revenue'].rolling(window=3).sum()
ts['rolling_3d_std'] = ts['daily_revenue'].rolling(window=3).std()   # volatility over the window

# min_periods -- allow partial windows at the start instead of NaN
ts['rolling_3d_avg_partial'] = ts['daily_revenue'].rolling(window=3, min_periods=1).mean()

# --- expanding: running/cumulative aggregate from the start ---
ts['running_avg'] = ts['daily_revenue'].expanding().mean()
ts['running_total'] = ts['daily_revenue'].expanding().sum()   # equivalent to cumsum() below

# --- shift: LAG / LEAD ---
ts['prev_day_revenue'] = ts['daily_revenue'].shift(1)     # LAG(daily_revenue, 1)
ts['next_day_revenue'] = ts['daily_revenue'].shift(-1)     # LEAD(daily_revenue, 1)

# --- diff: period-over-period change ---
ts['day_over_day_change'] = ts['daily_revenue'].diff(1)             # same as: daily_revenue - shift(1)
ts['day_over_day_pct'] = ts['daily_revenue'].pct_change() * 100      # % change, very common in trend reporting

# --- cumulative aggregates (simpler than expanding() for common cases) ---
ts['cumulative_revenue'] = ts['daily_revenue'].cumsum()
ts['running_max'] = ts['daily_revenue'].cummax()

ts.head(6)

# --- rolling/shift WITHIN groups (very common real ask -- e.g. per-customer trend) ---
sales = pd.DataFrame({
    'customer': ['A','A','A','B','B','B'],
    'date': pd.to_datetime(['2024-01-01','2024-01-08','2024-01-15']*2),
    'revenue': [100, 150, 130, 200, 180, 220]
}).sort_values(['customer','date'])

sales['customer_running_total'] = sales.groupby('customer')['revenue'].cumsum()
sales['customer_prev_order'] = sales.groupby('customer')['revenue'].shift(1)
sales
```

## Common mistakes / gotchas

- **Forgetting to sort by date/sequence before any rolling/shift/diff operation.** If the DataFrame isn't in chronological order, `rolling`/`shift`/`diff` will compute nonsense trends based on whatever the current row order happens to be — always `sort_values()` first, every time.
- **Expecting no NaN at the start of a rolling window.** A `rolling(window=3)` genuinely has no valid 3-row window until the 3rd row — the first 2 results being `NaN` is correct behavior, not a bug. Use `min_periods=1` only if a partial-window average is actually meaningful for your use case.
- **Doing rolling/shift/diff across the WHOLE DataFrame when you actually need it per-group** (e.g. rolling average per customer, not across all customers mixed together) — always pair with `groupby()` first (`df.groupby('customer')['revenue'].cumsum()`) whenever the trend should reset per entity rather than run across the entire table.
- **Confusing `diff()` with `pct_change()`** — `diff()` gives the absolute difference; `pct_change()` gives the relative/percentage difference. very importanters sometimes ask you to compute one when they actually want the other — clarify which is wanted before choosing.
- **Applying `rolling()` on unevenly-spaced dates without noticing** — a plain `rolling(window=3)` counts *rows*, not calendar days; if there are gaps in your date range (e.g. missing weekend data), a "3-row" window might actually span 5 calendar days. For calendar-based windows, pandas supports `rolling('3D')` with a DatetimeIndex — worth knowing this option exists.

## My Turn

1. Using the `ts` DataFrame, compute a 5-day rolling average and a 5-day rolling max of `daily_revenue`. How many `NaN` values appear at the start, and why exactly that many?
2. Compute day-over-day percentage change in `daily_revenue` using `pct_change()`. Which day had the single biggest percentage jump?
3. Using the `sales` DataFrame (grouped by customer), compute each customer's revenue change from their previous order (`diff()` within each group via `groupby().diff()`) and their running total (`cumsum()` within each group). Confirm customer A's and customer B's running totals never mix together.

## very important Questions

**Q1. "How would you compute a 7-day moving average of daily revenue?"**
> `df['revenue'].rolling(window=7).mean()`, after making sure the DataFrame is sorted by date first — rolling windows are purely row-order-based, so an unsorted DataFrame produces a meaningless average. I'd expect the first 6 rows to be `NaN` since there isn't a full 7-row window yet, which is correct, not an error.

**Q2. "What's the pandas equivalent of SQL's `LAG()` function?"**
> `.shift(1)` — it shifts every value down by one row, so each row now holds the previous row's value, exactly like `LAG(col, 1) OVER (ORDER BY ...)` in SQL. `.shift(-1)` gives the equivalent of `LEAD`, pulling the next row's value up instead.

**Q3. "What's the difference between `rolling()` and `expanding()`?"**
> `rolling(window=n)` uses a fixed-size window that slides forward — always exactly `n` rows behind the current one. `expanding()` uses a window that starts small and keeps growing to include every row from the beginning up to the current one — it's the natural way to compute a running/cumulative statistic like a running average or running total, versus a moving average that only looks at recent history.

**Q4. "How do you compute a running total per customer, so each customer's total doesn't mix with others?"**
> `df.sort_values(['customer','date']).groupby('customer')['revenue'].cumsum()` — grouping by customer first means the cumulative sum resets independently for each customer, rather than accumulating across the entire table as if it were one continuous sequence. This groupby-plus-cumulative pattern comes up constantly for any per-entity trend metric.


---

# Chapter 13: Categorical Dtype

## Why this matters on the job

When a column has a small, fixed set of repeated string values (city names, categories, status flags), storing it as plain `object`/string wastes memory and slows down groupby/sort operations. This is roughly analogous to using a lookup table with an integer key in a well-normalized SQL schema instead of repeating the full text string on every row.

## Core theory

`category` dtype stores each unique value once (the "categories") and represents every row as a small integer pointing to one of those categories — much like an enum, or an Excel data-validation dropdown backed by a fixed list, rather than free text. Benefits:
- **Memory** — dramatically less memory for columns with few unique values repeated across many rows.
- **Speed** — groupby, sorting, and comparisons on categorical columns can be faster since comparisons happen on the underlying integer codes.
- **Enforced/ordered values** — categories can be explicitly ordered (e.g. `'Low' < 'Medium' < 'High'`), enabling correct sorting and comparison operators on data that's logically ordinal but stored as text — something plain strings can't do (`'High' < 'Low'` alphabetically is wrong for ordinal data, categorical fixes this).

## Runnable code

```python
import pandas as pd
import numpy as np

data = {
    'order_id':     [101, 102, 103, 104, 105, 106, 107, 108],
    'category':     ['Electronics', 'Grocery', 'Electronics', 'Apparel',
                      'Grocery', 'Apparel', 'Electronics', 'Grocery'],
    'city':         ['Pune', 'Mumbai', 'Pune', 'Nagpur',
                      'Pune', 'Mumbai', 'Nagpur', 'Pune'],
    'priority':     ['Medium', 'Low', 'High', 'Medium', 'Low', 'High', 'Medium', 'Low']
}
df = pd.DataFrame(data)

# --- Memory comparison ---
df['category'].memory_usage(deep=True)                       # as object dtype
df['category'].astype('category').memory_usage(deep=True)    # as category dtype -- noticeably smaller, more dramatic at real-world row counts

# --- Converting a column ---
df['category'] = df['category'].astype('category')
df['city'] = df['city'].astype('category')
df.dtypes

df['category'].cat.categories     # the distinct category values
df['category'].cat.codes          # the underlying integer codes pandas uses internally

# --- Ordered categories -- for genuinely ordinal data ---
priority_order = ['Low', 'Medium', 'High']
df['priority'] = pd.Categorical(df['priority'], categories=priority_order, ordered=True)

df.sort_values('priority')                  # sorts by the logical order, NOT alphabetically
df[df['priority'] > 'Low']                   # comparison operators work correctly because it's ordered
df['priority'].cat.codes                     # Low=0, Medium=1, High=2

# --- Adding a new category safely ---
df['priority'] = df['priority'].cat.add_categories(['Critical'])
# df.loc[0, 'priority'] = 'Critical'   # would fail if 'Critical' wasn't first added to the categories list

# --- Common use: groupby on a categorical column ---
df.groupby('category', observed=True)['order_id'].count()
# observed=True: only show categories that actually appear in the data,
# rather than every possible category (including ones with zero rows) -- avoids a common surprise
```

## Common mistakes / gotchas

- **Trying to assign a value that isn't in the existing category list.** `df.loc[0,'priority'] = 'Critical'` raises an error if `'Critical'` wasn't already added via `.cat.add_categories()` — unlike a plain string column, categorical columns don't silently accept arbitrary new values, which is a feature (data validation) but surprises people expecting free-text behavior.
- **Forgetting `observed=True` in `groupby()` on categorical columns** — older pandas defaults can show every possible category combination in a multi-column groupby, including combinations with zero actual rows, cluttering the output with unwanted empty groups.
- **Converting a column to `category` too early, before cleaning it.** If the text still has inconsistent casing/whitespace (Chapter 9's problem), you'll end up with separate categories for `'Pune'` and `'pune'` — always clean text first, then convert to categorical.
- **Assuming categorical always helps.** For columns with mostly-unique values (like an `order_id` or a free-text comment field), converting to `category` provides little benefit and can even add overhead — it's specifically for low-cardinality columns (a small number of repeated distinct values relative to row count).

## My Turn

1. Convert `category` and `city` to categorical dtype, and compare `.memory_usage(deep=True)` before and after for each.
2. Create an ordered categorical for a `size` column with values `['S','M','L','XL']` in that logical order, then sort a small DataFrame by it and confirm it sorts correctly (not alphabetically, where `'L' < 'M'` alphabetically would be wrong for this ordering... actually check: is alphabetical order coincidentally the same as logical order here, or different? Verify by testing.)
3. Try to assign a category value that doesn't exist in the current category list and observe the error. Then fix it properly using `.cat.add_categories()` before retrying the assignment.

## very important Questions

**Q1. "When would you convert a column to categorical dtype, and why?"**
> When a column has a relatively small number of distinct values repeated across many rows — things like status, region, or product category — converting to `category` stores each unique value once and represents rows as integer codes internally, which saves substantial memory and can speed up groupby and sorting operations. I wouldn't do this for a column that's mostly unique values, like an order ID or a free-text comment, since there's little repetition to exploit.

**Q2. "How do ordered categoricals help with data that's ordinal but stored as text, like 'Low'/'Medium'/'High'?"**
> Plain string sorting is alphabetical, so `'High'` would sort before `'Low'` even though logically High should rank above both — alphabetical order doesn't match the real-world meaning. An ordered categorical lets me explicitly define the true order (`Low < Medium < High`), so `sort_values()` and comparison operators like `>` behave correctly according to the actual business meaning instead of alphabetical accident.

**Q3. Spot the bug:**
```python
df['status'] = df['status'].astype('category')
df.loc[0, 'status'] = 'Cancelled'
```
> If `'Cancelled'` wasn't already one of the existing categories in that column, this raises an error rather than silently adding a new value — categorical columns enforce a closed set of allowed values by design. The fix is `df['status'] = df['status'].cat.add_categories(['Cancelled'])` before making the assignment.

**Q4. "What's a downside or limitation of using categorical dtype?"**
> It adds a layer of validation/rigidity — you can't just assign an arbitrary new string value without first explicitly adding it to the category list, which can trip up code that expects free-text-like behavior. It's also not a universal performance win — for high-cardinality columns with mostly unique values, the overhead of maintaining the category mapping isn't worth it since there's little repetition to compress.

---

# Chapter 14: MultiIndex

## Why this matters on the job

You've already seen a MultiIndex without naming it — every `groupby()` on multiple columns produces one. This chapter is about being comfortable *reading and navigating* that structure, not deep theory — in real DA work you'll encounter it constantly as a side effect of groupby/pivot operations, and need to know how to get back to a normal flat table when you want one.

## Core theory

A **MultiIndex** is an index with more than one level — e.g. `(city, category)` pairs instead of a single flat label. Think of it like a composite primary key in SQL (`PRIMARY KEY (city, category)`), or a pivot table with two fields nested in the Rows area in Excel.

You'll meet MultiIndex in three main situations:
1. `groupby()` on multiple columns without `as_index=False`.
2. `pivot_table()`/`unstack()` results, when multiple value columns are involved.
3. `set_index()` called with a list of multiple columns explicitly.

The two moves you need most: **`.reset_index()`** to flatten a MultiIndex back into normal columns, and **`.loc[]`** with a tuple to select a specific combination of levels.

## Runnable code

```python
import pandas as pd
import numpy as np

data = {
    'city':      ['Pune', 'Pune', 'Mumbai', 'Mumbai', 'Nagpur'],
    'category':  ['Electronics', 'Grocery', 'Electronics', 'Grocery', 'Apparel'],
    'revenue':   [15000, 8000, 9000, 6000, 4000],
    'orders':    [10, 15, 6, 12, 5]
}
df = pd.DataFrame(data)

# --- MultiIndex from groupby ---
grouped = df.groupby(['city', 'category'])[['revenue','orders']].sum()
grouped                   # notice the two-level row index on the left: (city, category)
grouped.index              # MultiIndex object -- shows the tuples and level names

# --- Flattening back to a normal table ---
flat = grouped.reset_index()
flat                        # city and category are now regular columns again

# --- Selecting from a MultiIndex with .loc and a tuple ---
grouped.loc[('Pune', 'Electronics')]              # a single row, selected by the full tuple key
grouped.loc['Pune']                                 # all rows where the OUTER level is 'Pune' -- partial selection
grouped.loc[('Pune', 'Electronics'), 'revenue']    # drill down to a single value

# --- Setting a MultiIndex directly ---
df_indexed = df.set_index(['city', 'category'])
df_indexed.sort_index()      # good practice -- MultiIndex slicing works more reliably when sorted

# --- Swapping / reordering levels ---
grouped.swaplevel().sort_index()    # (category, city) instead of (city, category)

# --- Multi-level COLUMNS (common after pivoting multiple value fields) ---
pivot = pd.pivot_table(df, index='city', columns='category', values=['revenue','orders'], aggfunc='sum', fill_value=0)
pivot.columns               # a MultiIndex on the COLUMN axis: (revenue/orders, category)
pivot['revenue']             # select just the revenue "block" -- drops to a single-level column DataFrame
pivot.columns = ['_'.join(col) for col in pivot.columns]   # flatten multi-level columns into single strings, a common cleanup step
pivot.reset_index()
```

## Common mistakes / gotchas

- **Trying to filter a MultiIndex DataFrame like a normal one** (`df[df['city']=='Pune']` when `city` is part of the index, not a column) — this fails because `city` isn't a column anymore. Either `.reset_index()` first, or use `.loc['Pune']` / `.xs('Pune', level='city')` to select by index level.
- **Forgetting `.sort_index()` before slicing a MultiIndex** — partial-key `.loc` selection (like `grouped.loc['Pune']` above) can raise a `PerformanceWarning` or behave unreliably on an unsorted MultiIndex; sorting first avoids this.
- **Multi-level columns from `pivot_table` with multiple `values`** confusing people who expect flat column names — always check `.columns` after such a pivot; flattening with a list comprehension (as shown above) is a very common cleanup step before exporting or charting.
- **Not knowing `.xs()` exists** — it's the cleanest way to pull a "cross-section" at one level of a MultiIndex without needing the full tuple, e.g. `grouped.xs('Electronics', level='category')` gets every city's Electronics row regardless of level order.

## My Turn

1. Group the sample `df` by `city` and `category`, summing `revenue` and `orders`, producing a MultiIndex result. Then flatten it back to a normal table with `.reset_index()`.
2. From the still-MultiIndexed grouped result, select just Mumbai's rows using `.loc[]`, and separately select just the `'Electronics'` category across all cities using `.xs()`.
3. Build a pivot table with `values=['revenue','orders']` and `columns='category'`, inspect the resulting multi-level columns, then flatten them into single readable string column names (e.g. `'revenue_Electronics'`).

## very important Questions

**Q1. "What is a MultiIndex, and when do you typically encounter one?"**
> It's an index with more than one level — like a composite key made of several columns instead of one flat label. I run into it most often as the natural output of grouping by multiple columns, or pivoting with multiple value fields — pandas keeps the extra dimension as nested index levels rather than flattening it automatically, and I usually call `.reset_index()` right after if I want a normal flat table for further merging or exporting.

**Q2. "How would you select just the rows for one specific level value across a MultiIndex, ignoring the outer level?"**
> `.xs(value, level='level_name')` — cross-section selection. For example, if my index has levels `(city, category)` and I want every city's `'Electronics'` row, `df.xs('Electronics', level='category')` gets exactly that without needing to know or specify every city individually.

**Q3. Spot the bug:**
```python
grouped = df.groupby(['city','category'])['revenue'].sum()
print(grouped[grouped['city'] == 'Pune'])
```
> This raises an error — `city` isn't a column here, it's part of the MultiIndex, so `grouped['city']` doesn't exist. The fix is either `grouped.reset_index()` first and then filter normally on the `city` column, or use `grouped.loc['Pune']` to select directly by the index level.

**Q4. "Why would you flatten multi-level columns after a pivot with multiple value fields?"**
> Multi-level columns are awkward to reference in downstream code (`pivot[('revenue','Electronics')]` instead of a simple `pivot['revenue_Electronics']`), and most external tools — Excel exports, plotting libraries, other systems ingesting the file — expect single flat column headers, not a nested structure. Joining the levels into one string column name per column is a quick, standard cleanup step before exporting or visualizing.


---

# Chapter 15: Performance Basics

## Why this matters on the job

At 3-years-experience level, very importanters expect you to reason about *why* something is slow, not just get the right output. This chapter ties together threads from earlier chapters (vectorization, `.apply()`, `.copy()`) into an explicit performance mental model you can articulate out loud.

## Core theory

**Why loops over DataFrames are slow:** a `for` loop, or `.iterrows()`, processes one row at a time at the Python interpreter level — every arithmetic operation pays Python's per-operation overhead, row after row. Vectorized pandas/NumPy operations instead dispatch the whole column to compiled C code that processes the entire array in one call, with no per-row Python overhead. This is the exact same reason `numpy_array * 2` beats a Python loop over the array — you already know this instinct from NumPy, and it transfers directly.

**The vectorization mindset:** before writing any loop or `.apply()`, ask "can this be expressed as a whole-column operation instead?" Almost always: arithmetic, comparisons, `np.where`/`np.select`, `.map()`, `.isin()`, string `.str` methods, and groupby aggregations are all vectorized paths that should be your default reach.

**`.copy()` discipline:** operations that return a *view* into the original DataFrame versus a *copy* are not always predictable from the syntax alone (this is exactly what causes `SettingWithCopyWarning` in Chapter 3). The safe habit: whenever you intend to build a separate DataFrame you'll modify independently from the original, call `.copy()` explicitly — it costs a small amount of memory/time but removes all ambiguity about what you're mutating.

## Runnable code

```python
import pandas as pd
import numpy as np
import time

# Build a moderately large DataFrame to actually see a timing difference
n = 200_000
big = pd.DataFrame({
    'a': np.random.randint(1, 100, n),
    'b': np.random.randint(1, 100, n)
})

# --- Slow: row-by-row loop ---
start = time.time()
results = []
for i in range(len(big)):
    results.append(big['a'].iloc[i] + big['b'].iloc[i])
loop_time = time.time() - start

# --- Slow-ish: apply(axis=1) ---
start = time.time()
big.apply(lambda row: row['a'] + row['b'], axis=1)
apply_time = time.time() - start

# --- Fast: vectorized ---
start = time.time()
big['a'] + big['b']
vector_time = time.time() - start

print(f"loop:      {loop_time:.4f}s")
print(f"apply:     {apply_time:.4f}s")
print(f"vectorized:{vector_time:.4f}s")
# Typical result: loop and apply are both orders of magnitude slower than the vectorized version.
# Exact numbers vary by machine, but the RELATIVE gap is the point to internalize.

# --- .copy() discipline example ---
original = big.head(10)
subset = original[original['a'] > 50]          # ambiguous view/copy -- triggers warnings on mutation
subset_safe = original[original['a'] > 50].copy()   # explicit copy -- safe to modify independently
subset_safe['a'] = 0    # no warning, no ambiguity about what got changed

# --- Checking memory footprint (ties to Chapter 13) ---
big.info(memory_usage='deep')

# --- dtype downcasting -- another quick memory win ---
big['a'].memory_usage(deep=True)
big['a'].astype('int8').memory_usage(deep=True)   # if values genuinely fit in a smaller int range
# only do this when you've confirmed the value range actually fits -- int8 caps at 127
```

## Common mistakes / gotchas

- **Optimizing before profiling.** Don't rewrite working vectorized-adjacent code purely on instinct — for genuinely small DataFrames (a few thousand rows), the performance difference between `.apply()` and full vectorization often doesn't matter in practice. Reach for this chapter's habits by default for large data or production pipelines, not as dogma on every 50-row exploratory script.
- **`.iterrows()` returns a *copy* of each row as a Series**, meaning any mutation inside the loop doesn't actually change the original DataFrame — a double problem (slow AND doesn't do what people expect it to do).
- **Chained `.copy()` calls "just to be safe" everywhere**, even when not needed — unnecessary copying on very large DataFrames does cost real memory; the discipline is to copy *when you intend independent mutation*, not reflexively on every subset.
- **Downcasting dtypes without checking the actual value range first** — casting to `int8`/`float32` when the real data can exceed that range silently corrupts values (overflow) rather than raising an error in some pandas/NumPy operations. Always inspect `.min()`/`.max()` before downcasting in real work.

## My Turn

1. On a DataFrame of at least 100,000 rows, time a vectorized computation of `a * b + 10` versus the same logic written with `.apply(axis=1)`. Report the ratio of the two times.
2. Take a subset of a DataFrame with boolean masking, and demonstrate the difference between modifying it directly (watch for the warning) versus modifying it after an explicit `.copy()`.
3. Check `.info(memory_usage='deep')` on a DataFrame with a low-cardinality string column, then convert that column to `category` dtype and check memory again — report the percentage reduction.

## very important Questions

**Q1. "Why is a Python for-loop over DataFrame rows slow compared to a vectorized operation?"**
> A loop processes one row at a time at the Python interpreter level, paying per-operation Python overhead on every single row. A vectorized operation dispatches the entire column to pandas/NumPy's compiled C implementation, which processes the whole array in one call with none of that per-row overhead. It's the same principle as `numpy_array * 2` versus looping through a NumPy array manually — pandas is built on NumPy, so the same performance logic applies.

**Q2. "When, if ever, is `.apply()` an acceptable choice over full vectorization?"**
> When the logic genuinely can't be expressed as whole-column operations — some complex, deeply conditional or stateful row-level logic that doesn't reduce to `np.where`/`np.select`/boolean masking. Even then, I'd first check whether restructuring the logic (e.g. splitting into several vectorized boolean conditions) could avoid `.apply()` entirely, since it's rarely truly unavoidable — genuine cases are less common than people assume.

**Q3. "What's the practical difference between a view and a copy in pandas, and why does it matter for performance and correctness?"**
> A view shares underlying memory with the original DataFrame, so modifying it can modify the original too (or trigger ambiguity about whether it will); a copy is fully independent. Pandas doesn't always guarantee which one an operation returns, which is exactly why chained indexing triggers `SettingWithCopyWarning` — pandas genuinely doesn't know if your write landed on the real data or a throwaway copy. My habit is to call `.copy()` explicitly whenever I intend to build and modify a separate DataFrame, removing the ambiguity entirely rather than hoping I got lucky.

**Q4. "How would you reduce the memory footprint of a large DataFrame?"**
> A few standard moves: convert low-cardinality text columns to `category` dtype, since it stores each unique value once instead of repeating full strings; downcast numeric columns to smaller types like `int32`/`float32` (or even `int8`) when the actual value range fits safely; and load only the columns actually needed with `usecols=` at read time rather than loading everything and dropping columns afterward. I'd check `.info(memory_usage='deep')` before and after to confirm the actual savings rather than assuming.


---

# Chapter 16: Capstone — Real-World Messy Data Cleaning

## Why this matters on the job

This is the chapter that simulates an actual first-week-on-the-job task: "here's an export, clean it up and give me something usable." It combines every technique from Chapters 1-15 on one deliberately messy dataset. very importanters often give exactly this kind of open-ended cleaning task, and being able to narrate your process (not just produce final code) is what separates "knows the syntax" from "can actually do the job."

## The messy dataset

Type this in — it deliberately contains: inconsistent casing/whitespace, duplicate rows, missing values, wrong dtypes, inconsistent date formats, and an invalid foreign key.

```python
import pandas as pd
import numpy as np

messy_data = {
    'order_id':    [201, 202, 203, 204, 205, 206, 207, 208, 208, 209],
    'customer':    [' amit rao', 'Priya Shah', 'amit Rao ', 'NEHA JOSHI', 'Rahul Deshmukh',
                     'priya shah', 'Neha Joshi', 'Amit Rao', 'Amit Rao', 'Sanjay Patil'],
    'customer_id': [1, 2, 1, 3, 4, 2, 3, 1, 1, 99],       # 99 doesn't exist in the customers table below
    'category':    ['electronics', 'Grocery', 'Electronics', 'apparel', 'Grocery',
                     'Apparel', 'Electronics', 'Grocery', 'Grocery', 'Electronics'],
    'quantity':    ['1', '2', '1', '3', np.nan, '1', '2', '1', '1', '2'],   # note: stored as STRING, not int
    'unit_price':  [1499.0, 320.0, 599.0, 799.0, 450.0, 1299.0, 699.0, 60.0, 60.0, np.nan],
    'order_date':  ['2024-01-05', '01/06/2024', '2024-01-08', '2024-01-08', '2024-01-10',
                     '2024-01-12', '2024-01-15', '2024-01-15', '2024-01-15', '2024-01-18'],
    'city':        ['Pune', 'mumbai', 'Pune ', 'Nagpur', 'Pune',
                     'Mumbai', 'Nagpur', 'Pune', 'Pune', 'Pune']
}
messy_df = pd.DataFrame(messy_data)

customers = pd.DataFrame({
    'customer_id': [1, 2, 3, 4],
    'signup_city': ['Pune', 'Mumbai', 'Nagpur', 'Pune']
})

messy_df
```

## The cleaning process, step by step

**Step 1 — Inventory the damage.** Before fixing anything, understand the scope.

```python
messy_df.info()
messy_df.isna().sum()
messy_df.duplicated().sum()
messy_df.dtypes
```

**Step 2 — Fix dtypes.**

```python
df = messy_df.copy()   # never mutate the raw import -- keep messy_df as a reference to compare against later

df['quantity'] = pd.to_numeric(df['quantity'], errors='coerce')   # string -> numeric, invalid parses become NaN safely
df['order_date'] = pd.to_datetime(df['order_date'], errors='coerce', format='mixed')  # handles the mixed date formats
df.dtypes
```

**Step 3 — Standardize text.**

```python
df['customer'] = df['customer'].str.strip().str.title()
df['city'] = df['city'].str.strip().str.title()
df['category'] = df['category'].str.strip().str.title()

df[['customer','city','category']].drop_duplicates()   # sanity check -- should now show clean, consistent values
```

**Step 4 — Handle duplicates.**

```python
df.duplicated(keep=False).sum()          # inspect before dropping
df[df.duplicated(keep=False)]             # eyeball which rows are flagged -- order_id 208 appears twice, identical

df = df.drop_duplicates()
```

**Step 5 — Handle missing values, thoughtfully.**

```python
df.isna().sum()
# quantity: 1 missing -- fill with the median quantity for that PRODUCT CATEGORY (a defensible default, not a blind guess)
df['quantity'] = df['quantity'].fillna(df.groupby('category')['quantity'].transform('median'))

# unit_price: 1 missing -- this is more serious (can't reasonably guess a price), so flag it rather than fabricate a number
missing_price_orders = df[df['unit_price'].isna()]
print("Orders needing price follow-up:", missing_price_orders['order_id'].tolist())
# in a real job, this list goes back to the data owner -- don't silently invent a price for a revenue-driving field
```

**Step 6 — Validate the join / foreign key.**

```python
check = pd.merge(df, customers, on='customer_id', how='left', indicator=True)
orphans = check[check['_merge'] == 'left_only']
print("Orders with no matching customer record:", orphans['order_id'].tolist())
# order_id 209 (customer_id=99) has no match -- flag this as a data quality issue, don't just drop it silently
```

**Step 7 — Final assembled clean dataset + summary.**

```python
df['revenue'] = df['quantity'] * df['unit_price']

clean = df.dropna(subset=['unit_price']).copy()   # for reporting purposes, exclude the still-unresolved price row,
                                                     # but keep it in a separate "needs review" list, not delete it forever

summary = clean.groupby('category', observed=True).agg(
    total_revenue=('revenue', 'sum'),
    orders=('order_id', 'count'),
    avg_order_value=('revenue', 'mean')
).sort_values('total_revenue', ascending=False)

summary
```

## What a senior analyst would say about this process (very important framing)

> "I never clean blind. First I inventory what's actually wrong — nulls, dtypes, duplicates, date formats — before touching anything, so I know the scope. Then I fix structural issues first (dtypes, text standardization) because those often reveal *more* duplicates or nulls that weren't visible while the data was still messy. I handle missing values based on what they actually mean for that specific field — a missing quantity gets a defensible group-level estimate, but a missing price on a revenue field gets flagged for follow-up rather than guessed, because fabricating a number there could quietly distort a revenue report. And I always validate foreign keys with an indicator merge before trusting a join, because a silently dropped or duplicated row is much worse than an error message."

## My Turn (capstone-level)

1. Run the full pipeline above end to end yourself, typing every line — don't copy-paste. At each step, print the intermediate state and narrate out loud (even to yourself) what changed and why.
2. Extend Step 5: instead of filling missing `quantity` with the category median, try filling with the **customer's own average quantity** across their other orders (a groupby on `customer` instead of `category`). Which approach do you think is more defensible here, and why? There's no single correct answer — the point is to be able to justify a choice.
3. Produce one final pivot table from the cleaned data: total revenue by `city` (rows) and `category` (columns), zero-filled, sorted by total revenue descending. This is the kind of single deliverable a manager would actually ask for after "clean this up for me."

---

# Chapter 17: Final Cheat Sheet

Your pre-very important review sheet — every method from this book, organized by task.

## Creating & Inspecting
| Task | Method |
|---|---|
| Create DataFrame | `pd.DataFrame(dict_or_list)` |
| Create Series | `pd.Series(list, index=...)` |
| First/last rows | `.head(n)`, `.tail(n)` |
| Shape, columns, index | `.shape`, `.columns`, `.index` |
| Dtypes | `.dtypes` |
| Full summary | `.info()`, `.describe()` |
| Unique values / counts | `.unique()`, `.nunique()`, `.value_counts()` |

## Reading & Writing
| Task | Method |
|---|---|
| CSV | `pd.read_csv()` / `df.to_csv(index=False)` |
| Excel | `pd.read_excel()` / `df.to_excel(index=False)` |
| SQL | `pd.read_sql(query, conn)` / `df.to_sql(name, conn, if_exists=...)` |
| JSON | `pd.read_json()` / `df.to_json()` |
| Parse dates on load | `pd.read_csv(..., parse_dates=['col'])` |

## Selection & Filtering
| Task | Method |
|---|---|
| By label | `.loc[row_label, col_label]` |
| By position | `.iloc[row_pos, col_pos]` |
| Boolean filter | `df[condition]`, combine with `&`, `\|`, `~` |
| String-based filter | `.query('expr')` |
| Membership test | `.isin([...])` |

## Missing Data
| Task | Method |
|---|---|
| Detect | `.isna()`, `.notna()` |
| Count per column | `.isna().sum()` |
| Drop | `.dropna(subset=[...])` |
| Fill constant/stat | `.fillna(value)` |
| Fill sequential | `.ffill()`, `.bfill()` |

## Sorting, Ranking, Dedup
| Task | Method |
|---|---|
| Sort by column(s) | `.sort_values(['col1','col2'], ascending=[...])` |
| Sort by index | `.sort_index()` |
| Rank | `.rank(method='min'/'dense'/'first', ascending=...)` |
| Find duplicates | `.duplicated(keep=False)` |
| Drop duplicates | `.drop_duplicates(subset=[...], keep='first')` |

## GroupBy / Aggregating
| Task | Method |
|---|---|
| Aggregate | `df.groupby('col')['val'].sum()/.mean()/.count()` |
| Multiple aggs, named | `.groupby('col').agg(name=('col','func'), ...)` |
| Broadcast group stat to rows | `.groupby('col')['val'].transform('func')` |
| Custom per-group logic | `.groupby('col').apply(func)` |
| Row count vs non-null count | `.size()` vs `.count()` |

## Merging & Combining
| Task | Method |
|---|---|
| Join tables | `pd.merge(left, right, on=..., how='inner'/'left'/'right'/'outer')` |
| Debug a merge | `pd.merge(..., indicator=True, validate='many_to_one')` |
| Stack rows/columns | `pd.concat([df1, df2], axis=0 or 1)` |

## Reshaping
| Task | Method |
|---|---|
| Long -> wide | `pd.pivot_table(df, index=, columns=, values=, aggfunc=, fill_value=0)` |
| Wide -> long | `df.melt(id_vars=, var_name=, value_name=)` |
| MultiIndex reshape | `.stack()`, `.unstack()` |

## Strings (`.str`)
| Task | Method |
|---|---|
| Clean | `.str.strip()`, `.str.lower()`, `.str.title()` |
| Replace | `.str.replace(pattern, repl, regex=True/False)` |
| Search | `.str.contains(pattern, na=False)` |
| Split | `.str.split(delim, expand=True)` |
| Regex extract | `.str.extract(r'(...)')` |

## Dates (`.dt`)
| Task | Method |
|---|---|
| Convert to datetime | `pd.to_datetime(col, errors='coerce', format=...)` |
| Extract parts | `.dt.year`, `.dt.month`, `.dt.day_name()` |
| Date math | `(date1 - date2).dt.days` |
| Add offset | `+ pd.Timedelta(days=n)`, `+ pd.DateOffset(months=n)` |
| Time-bucketed agg | `.resample('W'/'M').sum()` (needs DatetimeIndex) |

## Apply / Map / Vectorize
| Task | Method |
|---|---|
| Vectorized if/else | `np.where(cond, a, b)` |
| Vectorized if/elif chain | `np.select([conds], [choices], default=...)` |
| Dict-based lookup | `.map({...})` |
| Custom per-row logic (last resort) | `.apply(func, axis=1)` |

## Window / Rolling
| Task | Method |
|---|---|
| Moving average/sum | `.rolling(window=n).mean()/.sum()` |
| Running/cumulative | `.expanding().mean()`, `.cumsum()`, `.cummax()` |
| Lag/lead | `.shift(n)` (positive=lag, negative=lead) |
| Period change | `.diff(n)`, `.pct_change()` |
| Per-group version | prefix with `.groupby('col')[...]` before any of the above |

## Categorical & MultiIndex
| Task | Method |
|---|---|
| Convert to category | `.astype('category')` |
| Ordered category | `pd.Categorical(col, categories=[...], ordered=True)` |
| Add new allowed category | `.cat.add_categories([...])` |
| Flatten MultiIndex | `.reset_index()` |
| Select from MultiIndex | `.loc[(level1, level2)]`, `.xs(value, level=...)` |

## Performance Checklist
- Vectorize first; `np.where`/`np.select` before `.apply()`; `.apply()` before a raw loop.
- `.copy()` explicitly whenever building a DataFrame you intend to modify independently.
- Convert low-cardinality text columns to `category`.
- Check `.dtypes` immediately after any load — silent `object` columns are the #1 hidden bug source.
- Sort before any rolling/shift/diff/resample operation.

---

*End of book. Good luck with your very importants.*
