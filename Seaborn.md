# Seaborn for Data Analyst Interviews (3 YOE)

**You already know:** Python basics, pandas, numpy, Matplotlib fundamentals (from the previous guide), Power BI/DAX, SQL.
**Goal:** Get job-ready in Seaborn in 4–5 days, 1–2 hrs/day, zero fluff.

**Mental model to hold onto:** Seaborn is **not a new tool** — it's a shortcut layer on top of Matplotlib, built specifically for statistical charts and for working directly with DataFrames. Where Matplotlib made you manually pull out columns (`ax.bar(df['region'], df['utilization'])`), Seaborn takes the whole DataFrame plus column *names*:

```python
# Matplotlib way (what you already know)
ax.bar(df['region'], df['utilization_pct'])

# Seaborn way (same idea, less typing, DataFrame-native)
sns.barplot(data=df, x='region', y='utilization_pct')
```

Every Seaborn chart still returns/works on a Matplotlib `ax` — so everything you learned last week (`ax.set_title()`, `plt.tight_layout()`, `fig.savefig()`) still applies without changes.

### Setup
```python
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
```
Install if needed: `pip install seaborn`.

---

## Day 1 — Why Seaborn, Styling, and Your First Charts

### 1.1 The one-line reason to use Seaborn over raw Matplotlib
Seaborn saves you the manual work for two things you'll do constantly as a DA: **splitting a chart by category (`hue`)** and **statistical aggregation (like averages with error bars) done automatically**. Matplotlib makes you write that logic yourself; Seaborn does it in one argument.

### 1.2 A theme in one line (this alone makes charts look "less default matplotlib")
```python
sns.set_theme(style='whitegrid')   # run once at the top of your script/notebook
```
Other options: `'darkgrid'`, `'white'`, `'ticks'`. `whitegrid` is a safe, clean default for business charts.

### 1.3 First chart — bar chart, utilization % by region (Finance project)
```python
data = {
    'region': ['North','South','East','West'],
    'utilization_pct': [82, 74, 91, 68]
}
df = pd.DataFrame(data)

fig, ax = plt.subplots(figsize=(8,5))
sns.barplot(data=df, x='region', y='utilization_pct', hue='region', legend=False, palette='Blues_d', ax=ax)
ax.set_title('Utilization % by Region')
plt.show()
```
Note `ax=ax` — passing your own axes keeps you in control of figsize/title exactly like Matplotlib. `hue='region', legend=False` is the current (non-deprecated) way to color bars by category without triggering a warning.

### 1.4 The `data=`, `x=`, `y=` pattern — this is 90% of Seaborn
Almost every Seaborn function follows: `sns.something(data=df, x='col1', y='col2', hue='col3')`. Learn this pattern once, it applies everywhere below.

### Common Mistakes — Day 1
- Passing raw arrays like Matplotlib (`sns.barplot(df['region'], df['utilization_pct'])`) — Seaborn wants `data=df, x='region', y='utilization_pct'`, not extracted columns.
- Forgetting `ax=ax` when you already made a `fig, ax` — Seaborn draws on the "current" axes by default, which gets confusing with subplots.
- Using `hue=` without `legend=False` when you don't want a redundant legend (e.g. hue is the same as x) — you'll get a legend repeating the x-axis categories.
- Calling `sns.set_theme()` mid-script after already plotting something — apply it once, at the top, before any charts.

### Interview Q&A — Day 1
**Q: What is Seaborn, in one sentence?**
A: A statistical plotting library built on top of Matplotlib that works directly with DataFrames and handles a lot of the styling and aggregation automatically.

**Q: If Seaborn is built on Matplotlib, why not just use Matplotlib for everything?**
A: I could, but Seaborn saves real time on two things: splitting a chart by a category column with `hue`, and computing statistical summaries (like mean + confidence interval) without writing that logic by hand. For quick EDA, that's faster; for full custom control I'll still drop to Matplotlib.

**Q: Write code to plot utilization % by region in Seaborn.**
A: *(give 1.3 code)*

**Q: How do you apply a consistent visual style across all your charts in a notebook?**
A: `sns.set_theme(style='whitegrid')` once at the top — every chart after that inherits the theme automatically.

---

## Day 2 — Categorical Plots: barplot, countplot, boxplot, violinplot

### 2.1 `countplot` — count of projects per RAG status (NPI project)
```python
data = {'status': ['Green']*950 + ['Amber']*300 + ['Red']*139}
df = pd.DataFrame(data)

fig, ax = plt.subplots(figsize=(7,5))
sns.countplot(data=df, x='status', hue='status', order=['Green','Amber','Red'],
              palette={'Green':'green','Amber':'orange','Red':'red'}, legend=False, ax=ax)
ax.set_title('Project Count by RAG Status')
plt.show()
```
`countplot` counts rows per category **for you** — no need to pre-aggregate with `.value_counts()` first, unlike a Matplotlib bar chart. `order=` forces the category order instead of alphabetical.

### 2.2 `barplot` with automatic aggregation — average utilization by region, with error bars
```python
data = {
    'region': ['North','North','South','South','East','East','West','West'],
    'utilization_pct': [80, 84, 72, 76, 89, 93, 66, 70]
}
df = pd.DataFrame(data)

fig, ax = plt.subplots(figsize=(8,5))
sns.barplot(data=df, x='region', y='utilization_pct', hue='region', legend=False,
            palette='Blues_d', errorbar='sd', ax=ax)
ax.set_title('Average Utilization % by Region (with variability)')
plt.show()
```
This is the big one to say out loud in interviews: **`sns.barplot()` doesn't just plot values — it averages them per category and adds error bars automatically.** In Matplotlib you'd `.groupby().mean()` first, then plot. `errorbar='sd'` shows standard deviation as the error bar.

### 2.3 `boxplot` — utilization % spread by region (same idea as Day 5 in the Matplotlib guide, less code)
```python
fig, ax = plt.subplots(figsize=(8,5))
sns.boxplot(data=df, x='region', y='utilization_pct', hue='region', legend=False, palette='Set2', ax=ax)
ax.set_title('Utilization % Spread by Region')
plt.show()
```
Compare to Matplotlib: no manual list-of-lists needed (`[df['North'], df['South']...]`) — Seaborn groups by the `x` column itself.

### 2.4 `violinplot` — boxplot's cousin, shows full distribution shape not just quartiles
```python
fig, ax = plt.subplots(figsize=(8,5))
sns.violinplot(data=df, x='region', y='utilization_pct', hue='region', legend=False, palette='Set2', ax=ax)
ax.set_title('Utilization % Distribution Shape by Region')
plt.show()
```
Use when someone asks "is there more detail than a boxplot?" — violin shows where values are *dense*, not just the five-number summary.

### Common Mistakes — Day 2
- Manually counting rows with `.value_counts()` before `countplot` — unnecessary, `countplot` does the counting itself.
- Assuming `barplot` shows raw values like Matplotlib's `bar()` — it averages by default if there are multiple rows per category. If you already have one value per category, this doesn't matter, but with raw/ungrouped data it silently aggregates.
- Wrong category order (defaults to alphabetical/appearance order) — always pass `order=[...]` when a specific order matters (like Red/Amber/Green).
- Confusing boxplot (quartiles/outliers) with violinplot (full distribution shape) when asked which to use — pick boxplot for a quick outlier check, violin for "show me the full shape."

### Interview Q&A — Day 2
**Q: What's the difference between `sns.barplot()` and a plain bar chart?**
A: Seaborn's `barplot` automatically aggregates — if you pass it raw rows, it computes the mean per category and adds an error bar showing variability. A plain Matplotlib bar chart just plots whatever values you hand it, no aggregation.

**Q: When would you use a violin plot instead of a boxplot?**
A: When I want to show the full shape of the distribution, not just the median and quartiles — useful if data might be bimodal (two peaks) which a boxplot would hide.

**Q: Write code for a countplot of RAG status.**
A: *(give 2.1 code)*

**Q: Your data isn't pre-aggregated — raw rows with a region column and a utilization value per row. How do you get an average-by-region bar chart in one line?**
A: `sns.barplot(data=df, x='region', y='utilization_pct')` — it aggregates for you, no `.groupby()` needed first.

---

## Day 3 — Distribution Plots: histplot, kdeplot, displot

### 3.1 `histplot` — distribution of project duration (compare to Matplotlib's `ax.hist()`)
```python
import numpy as np
np.random.seed(1)
data = {'duration_days': np.random.normal(45, 15, 500).round()}
df = pd.DataFrame(data)

fig, ax = plt.subplots(figsize=(8,5))
sns.histplot(data=df, x='duration_days', bins=20, color='steelblue', kde=True, ax=ax)
ax.set_title('Distribution of Project Duration (Days)')
plt.show()
```
`kde=True` overlays a smooth curve on top of the bars showing the estimated distribution shape — one argument, no separate calculation. That's the whole pitch for `histplot` over `plt.hist()`.

### 3.2 `kdeplot` — smooth distribution curve only, useful to compare two groups
```python
data = {
    'utilization_pct': [82,74,91,68,77,85,60,95,88,71,90,65,79,83,92,70],
    'region_type': ['HQ']*8 + ['Field']*8
}
df = pd.DataFrame(data)

fig, ax = plt.subplots(figsize=(8,5))
sns.kdeplot(data=df, x='utilization_pct', hue='region_type', fill=True, ax=ax)
ax.set_title('Utilization % Distribution — HQ vs Field')
plt.show()
```
This is the chart to reach for when asked "how do you compare the *shape* of two groups' distributions, not just their averages?" — `hue=` overlays both curves for a direct visual comparison.

### 3.3 `displot` — figure-level function, use only when you need small multiples
```python
sns.displot(data=df, x='utilization_pct', col='region_type', kde=True, height=4)
plt.show()
```
Different from `histplot`/`kdeplot`: `displot` is a **figure-level** function — it creates its own figure and can't take `ax=`. Use it specifically when you want automatic side-by-side panels via `col=`. For a single chart, stick to `histplot`/`kdeplot` since they play nicer with subplots.

### Common Mistakes — Day 3
- Trying to pass `ax=` into `displot()` — it errors, because `displot` is figure-level, not axes-level. Only `histplot`/`kdeplot`/`boxplot`/`barplot` etc. (axes-level) take `ax=`.
- Forgetting `fill=True` on `kdeplot` when comparing groups — unfilled curves overlapping are much harder to read than filled ones.
- Too many bins on `histplot` making the `kde=True` curve pointless to look at — if using the KDE overlay, fewer, wider bins usually reads cleaner.
- Confusing "figure-level" (`displot`, `relplot`, `catplot`) vs "axes-level" (`histplot`, `scatterplot`, `barplot`) functions — figure-level ones handle their own figure/subplots via `col=`/`row=`; axes-level ones plug into your own `fig, ax`.

### Interview Q&A — Day 3
**Q: What does `kde=True` do in a histogram?**
A: Overlays a smoothed curve estimating the underlying distribution shape, on top of the histogram bars — helps see the shape even if bin sizes are a bit noisy.

**Q: How would you compare the utilization distribution between two groups, like HQ vs Field staff?**
A: `sns.kdeplot()` with `hue='region_type', fill=True` — overlays both distributions as filled curves so you can directly compare shape and spread, not just averages.

**Q: What's the difference between an "axes-level" and "figure-level" Seaborn function?**
A: Axes-level functions like `histplot` or `barplot` plot onto an axes you control with `ax=`, so they fit into your own figure/subplot layout. Figure-level functions like `displot` or `relplot` manage their own figure and are used when you want automatic small multiples via `col=` or `row=`.

**Q: Write code to plot a histogram with a smoothed curve for project duration.**
A: *(give 3.1 code)*

---

## Day 4 — Relational Plots: scatterplot, lineplot, regplot, pairplot

### 4.1 `scatterplot` — utilization % vs revenue, colored by region (compare to Day 4's manual groupby loop in Matplotlib)
```python
data = {
    'utilization_pct': [82, 74, 91, 68, 77, 85, 60, 95],
    'revenue_lakhs':    [120, 95, 150, 80, 100, 130, 70, 160],
    'region': ['North','South','East','West','North','South','East','West']
}
df = pd.DataFrame(data)

fig, ax = plt.subplots(figsize=(8,5))
sns.scatterplot(data=df, x='utilization_pct', y='revenue_lakhs', hue='region', s=100, ax=ax)
ax.set_title('Utilization % vs Revenue by Region')
plt.show()
```
This is the exact chart from the Matplotlib guide's Day 4.3 — there, coloring by category needed a manual `groupby` + loop. Here, `hue='region'` does it in one argument. Say this comparison out loud in an interview — it shows you know both and *why* Seaborn is faster here.

### 4.2 `regplot` — scatter + trend line in one call (great for "is there a relationship?" questions)
```python
fig, ax = plt.subplots(figsize=(8,5))
sns.regplot(data=df, x='utilization_pct', y='revenue_lakhs', ax=ax)
ax.set_title('Utilization % vs Revenue — with Trend Line')
plt.show()
```
`regplot` fits and draws a linear regression line plus a shaded confidence band automatically. In Matplotlib you'd need `numpy.polyfit()` to do this by hand.

### 4.3 `lineplot` — project count over time, with automatic confidence interval if there are multiple values per x
```python
data = {
    'month': ['Jan','Feb','Mar','Apr','May','Jun']*2,
    'project_count': [120,135,150,142,160,175, 110,130,145,140,155,170],
    'year': ['2025']*6 + ['2026']*6
}
df = pd.DataFrame(data)

fig, ax = plt.subplots(figsize=(9,5))
sns.lineplot(data=df, x='month', y='project_count', hue='year', marker='o', ax=ax)
ax.set_title('Project Count Over Time — Year over Year')
plt.show()
```
Same idea as Matplotlib's multi-line chart from Day 1 (RAG trend), but comparing two full years takes one `hue=` argument instead of writing three separate `ax.plot()` calls.

### 4.4 `pairplot` — quick "check every numeric relationship at once" (figure-level, use sparingly, great for EDA questions)
```python
data = {
    'utilization_pct': [82, 74, 91, 68, 77, 85, 60, 95],
    'revenue_lakhs': [120, 95, 150, 80, 100, 130, 70, 160],
    'project_count': [12, 9, 15, 7, 10, 13, 6, 16]
}
df = pd.DataFrame(data)

sns.pairplot(df)
plt.show()
```
Plots every numeric column against every other numeric column in a grid, histograms on the diagonal. Use this as your answer to "how would you quickly explore relationships in a new dataset?" — one line, no manual subplot setup.

### Common Mistakes — Day 4
- Using `pairplot` on a DataFrame with many numeric columns (10+) — the grid becomes huge and unreadable; select relevant columns first: `sns.pairplot(df[['col1','col2','col3']])`.
- Forgetting `regplot`'s trend line is linear by default — if the relationship is clearly curved, say so rather than letting a straight line misrepresent it (mention `order=2` for a polynomial fit if pushed on this).
- Using `lineplot` on unsorted data — sort by the x-axis column first (`df.sort_values('month')`) or the line zigzags.
- Passing `ax=` to `pairplot` — like `displot`, it's figure-level and doesn't accept it.

### Interview Q&A — Day 4
**Q: How do you add a trend line to a scatter plot quickly?**
A: `sns.regplot(data=df, x='col1', y='col2')` — fits and draws a linear regression line with a confidence band in one line, no manual curve-fitting needed.

**Q: Write code to color scatter points by region.**
A: `sns.scatterplot(data=df, x='utilization_pct', y='revenue_lakhs', hue='region')` — one argument, versus a manual groupby loop in plain Matplotlib.

**Q: How would you quickly check for relationships across several numeric columns in a new dataset?**
A: `sns.pairplot(df)` — plots every pair of numeric columns against each other in a grid, so I can eyeball correlations before deciding what to dig into further.

**Q: What's the risk of relying only on `regplot`'s trend line?**
A: It fits a straight line by default — if the real relationship is curved, a linear fit can be misleading. I'd visually sanity-check the scatter first before trusting the line.

---

## Day 5 — Heatmaps, Multi-Panel Grids, and Review

### 5.1 `heatmap` — correlation matrix (one of the most common Seaborn interview asks)
```python
data = {
    'utilization_pct': [82, 74, 91, 68, 77, 85, 60, 95],
    'revenue_lakhs': [120, 95, 150, 80, 100, 130, 70, 160],
    'project_count': [12, 9, 15, 7, 10, 13, 6, 16],
    'avg_duration_days': [40, 55, 35, 60, 45, 38, 65, 30]
}
df = pd.DataFrame(data)

corr = df.corr(numeric_only=True)

fig, ax = plt.subplots(figsize=(7,6))
sns.heatmap(corr, annot=True, cmap='coolwarm', fmt='.2f', ax=ax)
ax.set_title('Correlation Matrix')
plt.show()
```
Workflow: `df.corr()` computes correlation between every numeric column pair → `sns.heatmap()` visualizes it. `annot=True` prints the number inside each cell — always turn this on, a heatmap without numbers forces the viewer to guess. This is a near-guaranteed interview question if EDA comes up.

### 5.2 `heatmap` on a pivoted table — RAG status count by region (turns a pandas pivot into a heatmap)
```python
data = {
    'region': ['North','North','North','South','South','East','East','East','West','West'],
    'status': ['Green','Green','Amber','Green','Red','Green','Amber','Green','Red','Amber']
}
df = pd.DataFrame(data)

pivot = df.pivot_table(index='region', columns='status', aggfunc='size', fill_value=0)

fig, ax = plt.subplots(figsize=(7,5))
sns.heatmap(pivot, annot=True, cmap='YlOrRd', fmt='d', ax=ax)
ax.set_title('RAG Status Count by Region')
plt.show()
```
Pattern to remember: **`pivot_table()` first, `heatmap()` second.** Seaborn can't read "long" data directly into a heatmap grid — it needs a pandas pivot (rows x columns of numbers) as input.

### 5.3 `catplot` — figure-level, small multiples across categories (e.g. utilization boxplot split per year, one panel each)
```python
data = {
    'region': ['North','South','East','West']*2,
    'utilization_pct': [82,74,91,68, 85,78,93,71],
    'year': ['2025']*4 + ['2026']*4
}
df = pd.DataFrame(data)

sns.catplot(data=df, x='region', y='utilization_pct', col='year', kind='bar', height=4)
plt.show()
```
`catplot` is the figure-level version of `barplot`/`boxplot`/etc. — `kind='bar'` picks which one, `col='year'` auto-splits into side-by-side panels. Faster than manually building `plt.subplots()` for this specific case.

### 5.4 Review — rebuild both portfolio charts in Seaborn from memory
Try these before checking the answer key:
1. Average utilization % by region, with error bars
2. Correlation heatmap of utilization %, revenue, and project count
3. Scatter plot of utilization vs revenue, colored by region, with a trend line

<details>
<summary>Answer key</summary>

```python
# 1. Average utilization by region with error bars
fig, ax = plt.subplots(figsize=(8,5))
sns.barplot(data=df, x='region', y='utilization_pct', hue='region', legend=False, errorbar='sd', ax=ax)
ax.set_title('Average Utilization % by Region')
plt.show()

# 2. Correlation heatmap
corr = df.corr(numeric_only=True)
fig, ax = plt.subplots(figsize=(7,6))
sns.heatmap(corr, annot=True, cmap='coolwarm', fmt='.2f', ax=ax)
ax.set_title('Correlation Matrix')
plt.show()

# 3. Scatter + trend line, colored by region
fig, ax = plt.subplots(figsize=(8,5))
sns.scatterplot(data=df, x='utilization_pct', y='revenue_lakhs', hue='region', s=100, ax=ax)
sns.regplot(data=df, x='utilization_pct', y='revenue_lakhs', scatter=False, ax=ax)
ax.set_title('Utilization vs Revenue by Region')
plt.show()
```
Note in #3: `sns.regplot(..., scatter=False)` layers just the trend line on top of the existing colored scatter — both functions can share the same `ax`.
</details>

### Common Mistakes — Day 5
- Feeding raw "long" data straight into `heatmap()` — it needs a matrix/pivot table, not row-by-row data. Always `pivot_table()` or `.corr()` first.
- Forgetting `annot=True` — a heatmap with only colors and no numbers is hard to read precisely, always annotate for business reporting.
- Forgetting `numeric_only=True` in `df.corr()` on newer pandas versions — it can error or warn if non-numeric columns are present.
- Passing `ax=` to `catplot` — figure-level again, same rule as `displot`/`pairplot`.
- Choosing a cmap that doesn't communicate direction — `coolwarm` or `RdBu` is standard for correlation (negative vs positive), avoid single-hue cmaps like `Blues` for correlation matrices since negative correlations won't stand out.

### Interview Q&A — Day 5
**Q: How would you visualize correlation between multiple numeric columns?**
A: `df.corr()` to get the correlation matrix, then `sns.heatmap(corr, annot=True, cmap='coolwarm')` to visualize it — numbers plus color make it easy to spot strong positive or negative relationships at a glance.

**Q: Write code to build a correlation heatmap for utilization, revenue, and project count.**
A: *(give 5.1 code)*

**Q: What has to happen to your data before you can put it into `sns.heatmap()`?**
A: It needs to already be a matrix — rows and columns of numbers, like a correlation table or a `pivot_table()` output. Heatmap doesn't aggregate raw rows itself.

**Q: What's `catplot` and when would you use it over `barplot`?**
A: It's the figure-level version that handles multiple categorical chart types (`kind='bar'`, `'box'`, `'violin'`, etc.) and can auto-split into panels with `col=`/`row=` — I'd use it when I want the same chart repeated per category (like per year) without manually building subplots.

---

## Rapid-Fire Quiz — 10 Questions

<details>
<summary>Q1. What does `sns.barplot()` do differently from Matplotlib's `ax.bar()` when given raw, ungrouped rows?</summary>
It automatically aggregates (averages) values per category and adds an error bar — Matplotlib's `bar()` just plots whatever values you give it.
</details>

<details>
<summary>Q2. What argument colors/splits a chart by a category column in Seaborn?</summary>
<code>hue='column_name'</code>
</details>

<details>
<summary>Q3. What must your data look like before calling <code>sns.heatmap()</code>?</summary>
A matrix — e.g. output of <code>df.corr()</code> or <code>df.pivot_table()</code> — not raw long-format rows.
</details>

<details>
<summary>Q4. What's the difference between an axes-level and figure-level Seaborn function?</summary>
Axes-level (e.g. <code>barplot</code>, <code>scatterplot</code>, <code>histplot</code>) plug into your own <code>fig, ax</code> via <code>ax=</code>. Figure-level (e.g. <code>catplot</code>, <code>displot</code>, <code>relplot</code>, <code>pairplot</code>) manage their own figure and support <code>col=</code>/<code>row=</code> for automatic small multiples — no <code>ax=</code>.
</details>

<details>
<summary>Q5. What one-line function call sets a global visual theme for all charts?</summary>
<code>sns.set_theme(style='whitegrid')</code>
</details>

<details>
<summary>Q6. How do you overlay a smoothed distribution curve on a histogram?</summary>
<code>sns.histplot(data=df, x='col', kde=True)</code>
</details>

<details>
<summary>Q7. Write the function call to add a trend line to a scatter plot.</summary>
<code>sns.regplot(data=df, x='col1', y='col2')</code>
</details>

<details>
<summary>Q8. What function quickly plots every numeric column against every other one, in a grid?</summary>
<code>sns.pairplot(df)</code>
</details>

<details>
<summary>Q9. What argument on <code>annot</code>/<code>heatmap</code> makes correlation numbers visible in each cell?</summary>
<code>annot=True</code>
</details>

<details>
<summary>Q10. If Seaborn returns a Matplotlib axes, can you still use <code>ax.set_title()</code> and <code>fig.savefig()</code> on a Seaborn chart?</summary>
Yes — Seaborn charts (axes-level ones, with <code>ax=</code> passed in) are regular Matplotlib axes underneath, so all your Matplotlib styling and saving methods still work unchanged.
</details>

---

## Cheat Sheet — Bringing Up Seaborn When Discussing Your Projects

Use these if the interviewer digs deeper after you've already mentioned Matplotlib, or asks "do you know Seaborn too?"

**On the Finance & Utilization Dashboard:**
> "For quick exploratory work before finalizing the DAX measures — like checking if utilization and revenue actually move together across regions — I'd use `sns.regplot()` in a notebook to get a scatter plot with a trend line in one line, faster than setting that up manually in Matplotlib or building a temporary Power BI visual just to sanity-check a hunch."

**On the PMO NPI Tracker (1,389+ projects, RAG status):**
> "If I wanted to check whether RAG status correlates with something like project duration or team size, I'd pull the relevant numeric columns and run a `sns.heatmap()` on the correlation matrix — that's a one-line way to scan for relationships across many variables at once, before deciding what's worth building into the actual dashboard."

**General pivot line if asked "Matplotlib or Seaborn — which do you actually reach for?":**
> "Seaborn first, for speed — most exploratory charts are one line with `hue=` doing what would be a manual groupby loop in Matplotlib. I drop down to Matplotlib when I need very specific control — custom annotations, exact subplot layouts, or fine-tuned styling that Seaborn's defaults don't cover."

**If asked "isn't this just duplicating what Power BI already does?":**
> "Seaborn's strength is statistical EDA — correlation heatmaps, distribution comparisons, quick trend lines — done in a notebook while I'm still exploring the data, before I know what the final dashboard should even show. Power BI is where that finished insight gets turned into something stakeholders click through themselves. Different stage of the same workflow, not overlapping tools."
