# Matplotlib for Data Analyst Interviews (3 YOE)

**You already know:** Python basics, pandas, numpy, Power BI/DAX, SQL.
**Goal:** Get job-ready in Matplotlib in 5–7 days, 1–2 hrs/day, zero fluff.

**Mental model to hold onto:** In Power BI you drag a field onto a visual and it draws the chart. In Matplotlib, you're the one telling it "draw a bar here, put this on the x-axis, color it like this." More typing, same end result — a chart. Every chart type you already use in Power BI (bar, line, pie, scatter) has a direct Matplotlib equivalent.

Two ways to write Matplotlib code — know both, but **prefer the second**:
```python
import matplotlib.pyplot as plt

# Style 1: pyplot style (quick, fine for one chart)
plt.plot([1,2,3],[4,5,6])
plt.show()

# Style 2: object-oriented / ax style (use this — scales to subplots, more control)
fig, ax = plt.subplots()
ax.plot([1,2,3],[4,5,6])
plt.show()
```
Interviewers notice if you only know `plt.plot()`. Use `fig, ax = plt.subplots()` everywhere in this guide.

---

## Day 1 — Setup, Line Charts, and pandas + matplotlib Basics

### 1.1 Setup
```python
import pandas as pd
import matplotlib.pyplot as plt
```
Run this once. If matplotlib isn't installed: `pip install matplotlib`.

### 1.2 Your first chart — from a DataFrame, not a random list
Real work always starts with a DataFrame. Sample data mimicking your NPI project (project count over time):

```python
data = {
    'month': ['Jan','Feb','Mar','Apr','May','Jun'],
    'project_count': [120, 135, 150, 142, 160, 175]
}
df = pd.DataFrame(data)

fig, ax = plt.subplots(figsize=(8,5))
ax.plot(df['month'], df['project_count'], marker='o', color='steelblue')
ax.set_title('NPI Project Count Over Time')
ax.set_xlabel('Month')
ax.set_ylabel('Number of Projects')
plt.show()
```

### 1.3 Titles, labels, figsize — the basics you'll use on every chart
```python
fig, ax = plt.subplots(figsize=(10,6))   # width, height in inches
ax.plot(df['month'], df['project_count'])
ax.set_title('NPI Project Count Over Time', fontsize=14)
ax.set_xlabel('Month')
ax.set_ylabel('Project Count')
plt.show()
```

### 1.4 Multiple lines on one chart (like a multi-series line chart in Power BI)
```python
data = {
    'month': ['Jan','Feb','Mar','Apr','May','Jun'],
    'green': [90, 95, 100, 98, 110, 120],
    'amber': [20, 25, 30, 28, 32, 35],
    'red':   [10, 15, 20, 16, 18, 20]
}
df = pd.DataFrame(data)

fig, ax = plt.subplots(figsize=(9,5))
ax.plot(df['month'], df['green'], label='Green', color='green', marker='o')
ax.plot(df['month'], df['amber'], label='Amber', color='orange', marker='o')
ax.plot(df['month'], df['red'], label='Red', color='red', marker='o')
ax.set_title('RAG Status Trend Over Time')
ax.legend()
plt.show()
```

### 1.5 Saving a chart (equivalent of exporting a Power BI visual)
```python
fig.savefig('rag_trend.png', dpi=300, bbox_inches='tight')
```
`dpi=300` = presentation quality. `bbox_inches='tight'` = no cut-off labels.

### Common Mistakes — Day 1
- Forgetting `plt.show()` in a script (Jupyter often shows it anyway, but don't rely on that habit).
- Using `plt.plot()` then later trying `ax.set_title()` — pick one style (`ax`) and stay consistent.
- Not setting `figsize` — default is small and looks cramped in a screenshot/report.
- Calling `savefig()` **after** `plt.show()` — this can save a blank chart. Save before you show, or don't show at all when exporting.
- Mismatched list lengths for x and y (`ax.plot(x, y)` where `len(x) != len(y)`) → throws an error immediately.

### Interview Q&A — Day 1
**Q: Why would you use Matplotlib instead of just building a chart in Power BI?**
A: When the chart is part of a Python pipeline — say I'm already cleaning data in pandas and need a quick sanity-check plot, or the chart needs to go into an automated report/email — it's faster to plot inline than to open Power BI. Power BI is still my choice for interactive dashboards end users touch.

**Q: What's the difference between `plt.plot()` and `ax.plot()`?**
A: `plt` acts on "whatever the current chart is" — fine for one quick plot. `ax` is a reference to a specific chart object, so it's more reliable, especially once you have multiple charts (subplots) in one figure. I default to `ax`.

**Q: Write code to plot a line chart of monthly revenue from a DataFrame.**
A:
```python
fig, ax = plt.subplots()
ax.plot(df['month'], df['revenue'])
ax.set_title('Monthly Revenue')
plt.show()
```

**Q: How do you save a chart as an image file?**
A: `fig.savefig('filename.png', dpi=300, bbox_inches='tight')` — I use `dpi=300` so it's not blurry if someone pastes it into a slide.

---

## Day 2 — Bar Charts (Vertical, Horizontal, Grouped, Stacked)

This is the chart type you'll use most as a DA. Maps directly to your **Finance Utilization dashboard**.

### 2.1 Simple vertical bar chart — utilization % by region
```python
data = {
    'region': ['North', 'South', 'East', 'West'],
    'utilization_pct': [82, 74, 91, 68]
}
df = pd.DataFrame(data)

fig, ax = plt.subplots(figsize=(8,5))
ax.bar(df['region'], df['utilization_pct'], color='steelblue')
ax.set_title('Utilization % by Region')
ax.set_ylabel('Utilization %')
plt.show()
```

### 2.2 Horizontal bar chart — better when category names are long
```python
fig, ax = plt.subplots(figsize=(8,5))
ax.barh(df['region'], df['utilization_pct'], color='seagreen')
ax.set_title('Utilization % by Region')
ax.set_xlabel('Utilization %')
plt.show()
```
Use `barh()` whenever labels are long (e.g. project names) — vertical bars force tiny rotated text that's hard to read.

### 2.3 Grouped bar chart — utilization % by region, split by quarter
```python
data = {
    'region': ['North','South','East','West'],
    'Q1': [78, 70, 88, 65],
    'Q2': [82, 74, 91, 68]
}
df = pd.DataFrame(data)

import numpy as np
x = np.arange(len(df['region']))   # positions: 0,1,2,3
width = 0.35

fig, ax = plt.subplots(figsize=(9,5))
ax.bar(x - width/2, df['Q1'], width, label='Q1', color='steelblue')
ax.bar(x + width/2, df['Q2'], width, label='Q2', color='orange')
ax.set_xticks(x)
ax.set_xticklabels(df['region'])
ax.set_title('Utilization % by Region — Q1 vs Q2')
ax.legend()
plt.show()
```
This is the one that trips people up. Think of it like Power BI's clustered bar: you're manually offsetting each series left/right of the category tick so bars sit side by side instead of overlapping.

### 2.4 Stacked bar chart — revenue by region, split by product line
```python
data = {
    'region': ['North','South','East','West'],
    'product_a': [40, 30, 55, 20],
    'product_b': [25, 20, 30, 18]
}
df = pd.DataFrame(data)

fig, ax = plt.subplots(figsize=(9,5))
ax.bar(df['region'], df['product_a'], label='Product A', color='steelblue')
ax.bar(df['region'], df['product_b'], bottom=df['product_a'], label='Product B', color='orange')
ax.set_title('Revenue by Region (Stacked by Product)')
ax.legend()
plt.show()
```
Key idea: `bottom=` tells the second bar to start where the first one ended. That's the whole trick to stacking.

### Common Mistakes — Day 2
- Using `ax.bar()` for grouped bars without offsetting `x` → bars overlap into one solid block.
- Forgetting `ax.set_xticks(x)` + `ax.set_xticklabels()` after using `np.arange()` → x-axis shows 0,1,2,3 instead of region names.
- Long category labels overlapping on vertical bars — switch to `barh()` or rotate with `plt.xticks(rotation=45)`.
- Forgetting `bottom=` in stacked bars → bars just sit on top of each other at the same baseline (look identical to grouped, but wrong).
- Not sorting data before plotting when order matters (e.g. want highest utilization first) — sort the DataFrame first with `.sort_values()`.

### Interview Q&A — Day 2
**Q: When do you use a horizontal bar chart instead of vertical?**
A: When category labels are long or there are many categories — horizontal keeps labels readable instead of rotated or truncated. I'd use it for something like "utilization by project name" but vertical for "utilization by region" since region names are short.

**Q: Write code for a grouped bar chart comparing Q1 vs Q2 utilization by region.**
A: *(give the Day 2.3 code)* — key part I'd say out loud: "I offset the bars using `x - width/2` and `x + width/2` so they sit side by side instead of stacking on the same position."

**Q: Why choose Matplotlib over an Excel chart for something like this?**
A: If utilization % is already sitting in a pandas DataFrame as part of a larger analysis script, plotting it right there avoids the copy-paste-to-Excel step and keeps everything reproducible — rerun the script, get the same chart, no manual rework.

**Q: What does the `bottom=` parameter do in a stacked bar chart?**
A: It tells matplotlib where the next segment should start on the y-axis, so it sits on top of the previous segment instead of overlapping it at zero.

---

## Day 3 — Pie / Donut Charts, Legends, Colors

Maps to your **NPI RAG status** breakdown.

### 3.1 Pie chart — RAG status distribution
```python
data = {'status': ['Green','Amber','Red'], 'count': [950, 300, 139]}
df = pd.DataFrame(data)

colors = ['green','orange','red']

fig, ax = plt.subplots(figsize=(6,6))
ax.pie(df['count'], labels=df['status'], autopct='%1.1f%%', colors=colors, startangle=90)
ax.set_title('RAG Status Distribution (1,389 Projects)')
plt.show()
```
`autopct='%1.1f%%'` shows percentage on each slice (1 decimal place). `startangle=90` starts the first slice at the top, like a clock at 12 — cleaner look.

### 3.2 Donut chart — same data, more modern look
```python
fig, ax = plt.subplots(figsize=(6,6))
wedges, texts, autotexts = ax.pie(
    df['count'], labels=df['status'], autopct='%1.1f%%',
    colors=colors, startangle=90,
    wedgeprops={'width': 0.4}   # this creates the donut hole
)
ax.set_title('RAG Status Distribution')
plt.show()
```
`wedgeprops={'width': 0.4}` is the only difference from a pie chart — it punches a hole in the middle.

### 3.3 Custom colors + legend placement
```python
fig, ax = plt.subplots(figsize=(6,6))
ax.pie(df['count'], labels=df['status'], colors=colors, startangle=90)
ax.legend(title='RAG Status', loc='upper left', bbox_to_anchor=(1, 1))
plt.show()
```
`bbox_to_anchor=(1,1)` pushes the legend outside the pie so it doesn't overlap slices — common ask in interviews ("how do you stop the legend covering the chart?").

### Common Mistakes — Day 3
- Not passing `colors=` and getting matplotlib's random default palette — for RAG status, always hardcode green/amber/red, don't leave it to chance.
- Forgetting `autopct` — pie chart shows slices with no values, useless in an interview demo.
- Using a pie chart for more than ~5 categories — say so out loud if asked: "I'd switch to a bar chart past 5 categories, pie slices get unreadable."
- Legend overlapping the pie — fix with `bbox_to_anchor`.
- Pie chart percentages not adding to 100 due to rounding — mention `autopct='%1.0f%%'` (0 decimals) can hide this, 1 decimal is usually safer.

### Interview Q&A — Day 3
**Q: When would you avoid a pie chart altogether?**
A: When there are more than 4–5 categories, or when I need viewers to compare exact values — bars are easier to compare precisely than slice angles. Pie is fine for something like RAG status with just 3 categories.

**Q: Write code to show a pie chart of RAG status with percentages labeled.**
A: *(give 3.1 code)*

**Q: How do you turn a pie chart into a donut chart?**
A: Add `wedgeprops={'width': 0.4}` inside `ax.pie()` — it cuts a hole proportional to that width value.

**Q: Why not just use Power BI's donut visual for this instead of matplotlib?**
A: I would, for a live dashboard end users interact with. I'd reach for Matplotlib if this chart needs to be auto-generated and dropped into a PDF/email report on a schedule, since that's a scripted, no-manual-refresh workflow.

---

## Day 4 — Histograms and Scatter Plots

New chart types not common in Power BI workflows — good to have ready, interviewers like testing these.

### 4.1 Histogram — distribution of project durations (days)
```python
import numpy as np
np.random.seed(1)
data = {'duration_days': np.random.normal(45, 15, 500).round()}
df = pd.DataFrame(data)

fig, ax = plt.subplots(figsize=(8,5))
ax.hist(df['duration_days'], bins=20, color='steelblue', edgecolor='black')
ax.set_title('Distribution of Project Duration (Days)')
ax.set_xlabel('Duration (days)')
ax.set_ylabel('Number of Projects')
plt.show()
```
`bins=20` = how many buckets. Too few bins hides shape, too many looks noisy — 15–30 is a safe default range to say out loud.

### 4.2 Scatter plot — utilization % vs revenue (finance project)
```python
data = {
    'utilization_pct': [82, 74, 91, 68, 77, 85, 60, 95],
    'revenue_lakhs':    [120, 95, 150, 80, 100, 130, 70, 160]
}
df = pd.DataFrame(data)

fig, ax = plt.subplots(figsize=(8,5))
ax.scatter(df['utilization_pct'], df['revenue_lakhs'], color='darkorange')
ax.set_title('Utilization % vs Revenue')
ax.set_xlabel('Utilization %')
ax.set_ylabel('Revenue (Lakhs)')
plt.show()
```
Use scatter when checking if two numeric variables move together — this is the "is there a relationship?" chart interviewers love asking about.

### 4.3 Scatter with color-coded categories (like a Power BI scatter with legend)
```python
data = {
    'utilization_pct': [82, 74, 91, 68, 77, 85, 60, 95],
    'revenue_lakhs': [120, 95, 150, 80, 100, 130, 70, 160],
    'region': ['North','South','East','West','North','South','East','West']
}
df = pd.DataFrame(data)

fig, ax = plt.subplots(figsize=(8,5))
for region, group in df.groupby('region'):
    ax.scatter(group['utilization_pct'], group['revenue_lakhs'], label=region)
ax.set_title('Utilization vs Revenue by Region')
ax.set_xlabel('Utilization %')
ax.set_ylabel('Revenue (Lakhs)')
ax.legend()
plt.show()
```
The `groupby` + loop pattern is how you color scatter points by category in matplotlib — there's no single "color by column" argument like Power BI's field well.

### Common Mistakes — Day 4
- Too few/too many bins on a histogram, distorting the shape — try 2–3 bin counts and pick the one that looks honest.
- Confusing histogram (`ax.hist()`, one numeric column, shows distribution) with bar chart (`ax.bar()`, categories vs values) — different purpose, different function.
- Scatter with mismatched-length x/y arrays — check `len(df['col1']) == len(df['col2'])` if you get an error.
- Forgetting `edgecolor` on histograms — bars blend together and look like one solid blob at a glance.
- Trying to color scatter points by category without the `groupby` loop — a single `ax.scatter()` call takes one color, not a column of categories.

### Interview Q&A — Day 4
**Q: When do you use a histogram vs a bar chart?**
A: Histogram is for one numeric column, showing how values are spread out — like project durations. Bar chart is for comparing values across categories, like regions. If the x-axis is "buckets of a number," it's a histogram; if it's "names," it's a bar chart.

**Q: Write code to plot a scatter plot of utilization vs revenue.**
A: *(give 4.2 code)*

**Q: How would you show a relationship between two numeric variables, and what would you look for?**
A: Scatter plot — I'd look for a trend, like points sloping upward suggesting higher utilization tracks with higher revenue, and I'd flag if the relationship isn't linear or if there are outliers pulling the pattern.

**Q: Why doesn't Power BI usually get used for histograms?**
A: Power BI can do it with a calculated bucket column, but it's clunky — matplotlib's `hist()` bins the data automatically in one line, which is faster for quick exploratory analysis.

---

## Day 5 — Boxplots and Subplots

### 5.1 Boxplot — utilization % spread by region
```python
data = {
    'North': [78, 82, 85, 90, 70, 88],
    'South': [65, 70, 74, 72, 60, 78],
    'East':  [88, 91, 95, 85, 92, 89],
    'West':  [60, 65, 68, 70, 55, 63]
}
df = pd.DataFrame(data)

fig, ax = plt.subplots(figsize=(8,5))
ax.boxplot([df['North'], df['South'], df['East'], df['West']],
           labels=['North','South','East','West'])
ax.set_title('Utilization % Spread by Region')
ax.set_ylabel('Utilization %')
plt.show()
```
Boxplot = min/max/median/quartiles in one shape. Use it when asked "how do you spot outliers or compare spread across groups" — that's exactly what this answers, and Power BI doesn't have a native boxplot visual (needs a custom visual), so this is a genuine matplotlib advantage to mention.

### 5.2 Subplots — multiple charts in one figure (like a Power BI page with several visuals)
```python
fig, axes = plt.subplots(1, 2, figsize=(12,5))   # 1 row, 2 columns

axes[0].bar(['North','South','East','West'], [82,74,91,68], color='steelblue')
axes[0].set_title('Utilization % by Region')

axes[1].pie([950,300,139], labels=['Green','Amber','Red'], colors=['green','orange','red'], autopct='%1.0f%%')
axes[1].set_title('RAG Status Distribution')

plt.tight_layout()
plt.show()
```
`plt.subplots(1, 2)` gives you a grid — 1 row, 2 columns. `axes` becomes an array; `axes[0]`, `axes[1]` are each an individual chart. `plt.tight_layout()` auto-fixes spacing so titles/labels don't overlap.

### 5.3 A 2x2 grid — the layout you'll actually use for a "mini dashboard" demo
```python
fig, axes = plt.subplots(2, 2, figsize=(12,9))

axes[0,0].bar(['North','South','East','West'], [82,74,91,68], color='steelblue')
axes[0,0].set_title('Utilization % by Region')

axes[0,1].pie([950,300,139], labels=['Green','Amber','Red'], colors=['green','orange','red'], autopct='%1.0f%%')
axes[0,1].set_title('RAG Status')

axes[1,0].plot(['Jan','Feb','Mar','Apr'], [120,135,150,142], marker='o', color='darkorange')
axes[1,0].set_title('Project Count Trend')

axes[1,1].hist(np.random.normal(45,15,300), bins=15, color='seagreen', edgecolor='black')
axes[1,1].set_title('Project Duration Distribution')

fig.suptitle('Portfolio Overview', fontsize=16)
plt.tight_layout()
plt.show()
```
`axes[row, col]` for a 2x2 grid. `fig.suptitle()` sets one title over the whole figure (different from `ax.set_title()` which is per-chart).

### Common Mistakes — Day 5
- Forgetting boxplot needs a **list of arrays/series**, not a single column — `ax.boxplot([series1, series2])`, not `ax.boxplot(df)`.
- Indexing subplots wrong — 1D grid uses `axes[0]`, `axes[1]`; 2D grid uses `axes[0,0]`, `axes[0,1]`, etc. Mixing these up throws an IndexError.
- Skipping `plt.tight_layout()` — titles and axis labels overlap between subplots, looks messy in a live demo.
- Reusing the same `ax` variable name for different subplots by mistake, overwriting a chart you already built.
- `figsize` too small for a 2x2 grid — each subplot ends up tiny and unreadable. Scale figsize up as you add rows/columns.

### Interview Q&A — Day 5
**Q: How do you put 4 charts on one figure?**
A: `fig, axes = plt.subplots(2, 2, figsize=(12,9))` creates a 2x2 grid, then I plot on `axes[0,0]`, `axes[0,1]`, etc., and call `plt.tight_layout()` at the end so nothing overlaps.

**Q: Why use a boxplot instead of just showing averages?**
A: An average hides the spread — two regions can have the same average utilization but very different consistency. Boxplot shows the median, the range, and outliers in one view, which is more honest for spotting problem areas.

**Q: Write code for a boxplot comparing utilization spread across 4 regions.**
A: *(give 5.1 code)*

**Q: What's the difference between `ax.set_title()` and `fig.suptitle()`?**
A: `set_title()` labels one individual chart; `suptitle()` puts one title over the entire figure, above all the subplots — useful for a "dashboard" title.

---

## Day 6 — Styling: Colors, Legends, Annotations, Polish

### 6.1 Consistent color palette across a project (RAG colors as a dict — reusable)
```python
rag_colors = {'Green': 'green', 'Amber': 'orange', 'Red': 'red'}

data = {'status': ['Green','Amber','Red'], 'count': [950, 300, 139]}
df = pd.DataFrame(data)
colors = [rag_colors[s] for s in df['status']]

fig, ax = plt.subplots(figsize=(7,5))
ax.bar(df['status'], df['count'], color=colors)
ax.set_title('RAG Status Count')
plt.show()
```
Interview-worthy habit: define colors once as a dict, reuse everywhere — shows you think about consistency across a report, not just one chart.

### 6.2 Data labels on bars (value shown above each bar — common ask)
```python
fig, ax = plt.subplots(figsize=(8,5))
bars = ax.bar(df['status'], df['count'], color=colors)

for bar in bars:
    height = bar.get_height()
    ax.text(bar.get_x() + bar.get_width()/2, height + 10, str(height),
            ha='center', va='bottom')

ax.set_title('RAG Status Count')
plt.show()
```
`bar.get_x() + bar.get_width()/2` = horizontal center of the bar. `ha='center'` = horizontally center the text on that point.

### 6.3 Rotating x-axis labels (fixes overlapping category names)
```python
fig, ax = plt.subplots(figsize=(9,5))
ax.bar(['Project Alpha','Project Beta Long Name','Project Gamma','Project Delta Extended'], [82,74,91,68])
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
plt.show()
```

### 6.4 Annotating a specific point (e.g. flagging a dip in a trend line)
```python
fig, ax = plt.subplots(figsize=(8,5))
months = ['Jan','Feb','Mar','Apr','May','Jun']
values = [120,135,90,142,160,175]
ax.plot(months, values, marker='o')
ax.annotate('Dip — vendor delay', xy=('Mar', 90), xytext=('Mar', 60),
            arrowprops=dict(arrowstyle='->', color='red'), color='red')
ax.set_title('Project Count Over Time')
plt.show()
```
Good for storytelling in an interview demo — shows you can call out an insight, not just plot data.

### 6.5 Style sheets — quick polish with one line
```python
plt.style.use('seaborn-v0_8')   # or 'ggplot', 'fivethirtyeight'
fig, ax = plt.subplots(figsize=(8,5))
ax.bar(df['status'], df['count'], color=colors)
ax.set_title('RAG Status Count')
plt.show()
```
One-line way to make charts look less "default matplotlib" without manual styling.

### Common Mistakes — Day 6
- Hardcoding colors inconsistently across charts in the same report (Green ≠ same green everywhere) — use a dict/palette once, reuse it.
- Data labels overlapping the bar or floating too far — adjust the small offset (`height + 10`) based on your value scale.
- Rotating labels but forgetting `ha='right'` — text rotates but doesn't align under the tick properly.
- Annotating with wrong `xy` coordinates that don't match actual data points — arrow points to empty space.
- Applying `plt.style.use()` globally and forgetting it affects **every** chart for the rest of the session — reset with `plt.style.use('default')` if needed.

### Interview Q&A — Day 6
**Q: How do you add value labels on top of bars?**
A: Loop through the bar objects returned by `ax.bar()`, get each bar's height with `.get_height()`, and place text at that x/y position with `ax.text()`.

**Q: How do you handle long category names that overlap on the x-axis?**
A: Either rotate the labels with `plt.xticks(rotation=45, ha='right')`, or switch to a horizontal bar chart if there are many long names — horizontal is usually cleaner.

**Q: Why keep a consistent color scheme across charts in the same report?**
A: So the same category means the same thing visually everywhere — Red always means Red RAG status, not accidentally reused for something else in another chart. It also just looks more professional and intentional.

**Q: Write code to highlight and label a specific dip in a trend line.**
A: *(give 6.4 code)* — I'd explain it as: "I use `annotate()` to point an arrow at the exact data point and add a short note, so the chart tells the story instead of making the viewer guess."

---

## Day 7 — Matplotlib vs Seaborn vs Power BI, Review, and Mock Interview

### 7.1 The tool comparison (say this confidently, don't hedge)

| | **Matplotlib** | **Seaborn** | **Power BI** |
|---|---|---|---|
| Built on | Base Python plotting library | Built on top of Matplotlib | Standalone BI tool |
| Best for | Full control, custom/one-off charts, automated reports | Fast statistical charts (correlation, distributions) with less code | Interactive dashboards for business users |
| Interactivity | None (static image) — needs Plotly for interactive | None (static image) | Fully interactive, drag-and-drop, filters/slicers |
| Learning curve | Verbose but predictable | Fewer lines, less control | No code, GUI-based |
| Typical DA use case | Quick plot inside a pandas/Python analysis script; scripted PDF/email reports | Correlation heatmaps, distribution comparisons in EDA | Stakeholder-facing dashboards, self-serve reporting |
| Data source | Any pandas DataFrame | Any pandas DataFrame | Needs data model/connections set up |

**One-line answer if asked "why not just use Power BI for everything?"**
"Power BI is my default for anything a stakeholder will click through and filter themselves. I'd use Matplotlib when the chart is a byproduct of a Python analysis I'm already running, or needs to be auto-generated on a schedule without opening a BI tool."

### 7.2 Seaborn — the 10-minute version (enough to not be blindsided)
```python
import seaborn as sns

fig, ax = plt.subplots(figsize=(8,5))
sns.barplot(data=df, x='status', y='count', hue='status', palette=colors, legend=False, ax=ax)
ax.set_title('RAG Status Count (Seaborn)')
plt.show()
```
Notice: seaborn still hands back a matplotlib `ax` — you style it exactly like everything else you learned this week (`ax.set_title()`, etc.). That's the real point: **seaborn is matplotlib with shortcuts for statistical charts**, not a separate skill.

### 7.3 Full review — rebuild your two portfolio charts from memory
Try coding these without looking back before checking the answer key:
1. Bar chart of utilization % by region (Finance project)
2. Donut chart of RAG status distribution (NPI project)
3. A 2-chart subplot combining both

<details>
<summary>Answer key</summary>

```python
# 1. Bar chart
fig, ax = plt.subplots(figsize=(8,5))
ax.bar(['North','South','East','West'], [82,74,91,68], color='steelblue')
ax.set_title('Utilization % by Region')
plt.show()

# 2. Donut chart
fig, ax = plt.subplots(figsize=(6,6))
ax.pie([950,300,139], labels=['Green','Amber','Red'], colors=['green','orange','red'],
       autopct='%1.1f%%', wedgeprops={'width':0.4})
ax.set_title('RAG Status Distribution')
plt.show()

# 3. Subplot combining both
fig, axes = plt.subplots(1, 2, figsize=(12,5))
axes[0].bar(['North','South','East','West'], [82,74,91,68], color='steelblue')
axes[0].set_title('Utilization % by Region')
axes[1].pie([950,300,139], labels=['Green','Amber','Red'], colors=['green','orange','red'], autopct='%1.0f%%')
axes[1].set_title('RAG Status')
plt.tight_layout()
plt.show()
```
</details>

### Interview Q&A — Day 7
**Q: What's the actual difference between Matplotlib and Seaborn?**
A: Seaborn is built on top of Matplotlib — it gives shorter syntax for statistical charts like distributions and correlations, and nicer default styling. Under the hood it still returns a matplotlib figure/axes, so anything I know in matplotlib still applies for customizing a seaborn chart.

**Q: If your manager asks for an interactive dashboard, which tool do you pick?**
A: Power BI — that's what it's built for. Matplotlib and Seaborn produce static images, no filtering/drilldown for the end user.

**Q: Give an example from your own work where you'd use matplotlib instead of Power BI.**
A: On the NPI tracker, if I needed to auto-email a weekly PDF summary of RAG status to leadership without them opening Power BI, I'd generate that chart in Python and embed it in the email script — fully automated, no manual export step.

**Q: What's one thing Matplotlib can do that Power BI's native visuals can't (or make hard)?**
A: Boxplots — Power BI needs a custom/marketplace visual for that, Matplotlib does it in one line: `ax.boxplot()`.

---

## Rapid-Fire Quiz — 10 Questions

<details>
<summary>Q1. What's the correct order: <code>fig, ax = plt.subplots()</code> then what to draw a bar chart?</summary>
<code>ax.bar(x, y)</code>
</details>

<details>
<summary>Q2. How do you save a chart to a file at high resolution?</summary>
<code>fig.savefig('name.png', dpi=300, bbox_inches='tight')</code>
</details>

<details>
<summary>Q3. What function makes a chart show category values as buckets/ranges instead of exact categories?</summary>
<code>ax.hist()</code> — a histogram
</details>

<details>
<summary>Q4. What parameter in <code>ax.pie()</code> shows percentages on each slice?</summary>
<code>autopct='%1.1f%%'</code>
</details>

<details>
<summary>Q5. What parameter stacks one bar on top of another?</summary>
<code>bottom=</code> in <code>ax.bar()</code>
</details>

<details>
<summary>Q6. How do you create a 2x2 grid of charts in one figure?</summary>
<code>fig, axes = plt.subplots(2, 2, figsize=(12,9))</code>, then index with <code>axes[0,0]</code>, <code>axes[0,1]</code>, <code>axes[1,0]</code>, <code>axes[1,1]</code>
</details>

<details>
<summary>Q7. What's the difference between <code>ax.set_title()</code> and <code>fig.suptitle()</code>?</summary>
<code>set_title()</code> labels one chart; <code>suptitle()</code> titles the whole figure across all subplots.
</details>

<details>
<summary>Q8. What chart type would you use to check for a relationship between two numeric columns?</summary>
Scatter plot — <code>ax.scatter(x, y)</code>
</details>

<details>
<summary>Q9. What command fixes overlapping subplot titles/labels?</summary>
<code>plt.tight_layout()</code>
</details>

<details>
<summary>Q10. Is Seaborn a replacement for Matplotlib or built on top of it?</summary>
Built on top of it — a seaborn chart still returns a matplotlib figure/axes you can style normally.
</details>

---

## Cheat Sheet — Bringing Up Matplotlib When Discussing Your Projects

Use these lines if the interviewer pivots from "walk me through your project" to "did you use any Python for this?" or "how would you do this outside Power BI?"

**On the Finance & Utilization Dashboard:**
> "The dashboard itself is Power BI with 80+ DAX measures for utilization and revenue calcs. If I needed to hand off a quick static snapshot — say, a one-pager for an exec who won't open Power BI — I'd pull the same aggregated data into pandas and generate the utilization-by-region bar chart with Matplotlib, so it's just a script run away, no dashboard access needed."

**On the PMO NPI Tracker (1,389+ projects, RAG status):**
> "For the RAG status breakdown, Power BI's donut visual handles the live, interactive version. But if leadership wants a scheduled weekly PDF/email summary instead of logging into Power BI, that's exactly the case for a Matplotlib donut chart generated by a script — same insight, zero manual dashboard interaction needed on their end."

**General pivot line if they ask "so you know Python for visualization too?":**
> "Yes — pandas for the data prep, Matplotlib for the plotting. I think of it as the code version of what I already do visually in Power BI: same chart types, same design decisions about when to use bar vs line vs pie, just expressed in code instead of a drag-and-drop canvas."

**If they push "isn't that redundant with Power BI?":**
> "They solve different problems. Power BI is for people who need to explore data themselves — filter, drill down, self-serve. Matplotlib is for when I need a chart embedded in a script, a report, or an automated pipeline where nobody's clicking around — it's about where the chart needs to *live*, not which one is 'better'."
