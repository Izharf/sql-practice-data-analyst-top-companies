# Python for Data Analysts — Interview & Job-Ready Notes

> Curated, cleaned, and modernized from Durgasoft's Python course notes (Hyderabad), rebuilt specifically for **Data Analyst** interview prep and real-time job work.
> Library-specific content (NumPy, Pandas, Matplotlib, Seaborn) is intentionally **excluded** — this covers **core Python** only, since you already have separate notes for those libraries.
> Outdated references (Python 2, old version numbers, unrelated backend/software-engineering topics) have been removed or updated. A few topics not in the original notes but commonly asked in Data Analyst interviews have been added — marked with **[Added]**.

---

## Index

1. [Python Fundamentals](#1-python-fundamentals)
2. [Identifiers & Reserved Words](#2-identifiers--reserved-words)
3. [Data Types](#3-data-types)
4. [Type Casting](#4-type-casting)
5. [Operators](#5-operators)
6. [Input / Output & String Formatting](#6-input--output--string-formatting)
7. [Flow Control](#7-flow-control)
8. [Strings](#8-strings)
9. [Lists](#9-lists)
10. [Tuples](#10-tuples)
11. [Sets](#11-sets)
12. [Dictionaries](#12-dictionaries)
13. [Comprehensions [Added]](#13-comprehensions-added)
14. [Functions](#14-functions)
15. [args, *kwargs and Scope [Added/Expanded]](#15-args-kwargs-and-scope-addedexpanded)
16. [Lambda, map, filter, reduce](#16-lambda-map-filter-reduce)
17. [Iterators & Generators](#17-iterators--generators)
18. [Decorators](#18-decorators)
19. [Modules & Packages](#19-modules--packages)
20. [File Handling (text, CSV, JSON)](#20-file-handling-text-csv-json)
21. [Exception Handling](#21-exception-handling)
22. [Object-Oriented Programming (OOP)](#22-object-oriented-programming-oop)
23. [Regular Expressions](#23-regular-expressions)
24. [Dates & Times [Added]](#24-dates--times-added)
25. [Python + Databases (SQL connectivity)](#25-python--databases-sql-connectivity)
26. [Copy Semantics: Mutable vs Immutable, Shallow vs Deep Copy [Added]](#26-copy-semantics-mutable-vs-immutable-shallow-vs-deep-copy-added)
27. [Environment & Package Management (job-relevant basics) [Added]](#27-environment--package-management-job-relevant-basics-added)
28. [Data Analyst Interview Question Bank [Added]](#28-data-analyst-interview-question-bank-added)
29. [Common Coding Patterns Asked in Interviews [Added]](#29-common-coding-patterns-asked-in-interviews-added)
30. [Essential Built-ins You'll Actually Use [Added]](#30-essential-built-ins-youll-actually-use-added)
31. [Writing Custom Iterators & Context Managers [Added]](#31-writing-custom-iterators--context-managers-added)
32. [A Few More Concepts Worth Knowing at 3 Years [Added]](#32-a-few-more-concepts-worth-knowing-at-3-years-added)
33. [Real Gotchas & Everyday Idioms [Added]](#33-real-gotchas--everyday-idioms-added)

---

## Topics removed from the original notes (and why)

These were in the original Durgasoft notes but removed here because they are backend/software-engineering-heavy and rarely relevant to Data Analyst interviews or day-to-day analyst work:

- **Multithreading & Synchronization** (Thread, Lock, Condition, Producer-Consumer) — relevant for backend/systems engineering, not data analysis.
- **100 star/number pattern programs** — a coding-practice exercise set, not something asked in Data Analyst interviews; replaced with a short, focused set of the pattern-style questions that *do* come up (see §29).
- Deep **Garbage Collector internals** (`gc` module tuning, generational GC) — kept only a 2-line practical summary under OOP.
- Heavy **Java/C code comparisons** used throughout the original as teaching aids — removed to keep this reference Python-only and interview-focused.


---

## 1. Python Fundamentals

- Python is a general-purpose, high-level, interpreted programming language created by **Guido van Rossum**, first released publicly in **1991**.
- It supports both procedural and object-oriented programming.
- **Why it matters for Data Analysts:** Python is one of the two dominant languages in data analytics (along with SQL/R) because of its huge ecosystem for data handling (Pandas), numerical computation (NumPy), and visualization (Matplotlib/Seaborn) — all covered in your separate library notes.

**Key characteristics:**
- **Dynamically typed** — you don't declare variable types; the interpreter infers them from the assigned value.
- **Interpreted** — no separate compile step; the Python interpreter (CPython, the standard implementation) runs code directly.
- **Platform independent** — the same `.py` file runs on Windows/Linux/Mac as long as Python is installed.
- **Extensive standard library and third-party ecosystem** — this is Python's biggest advantage for data work (Pandas, NumPy, requests, openpyxl, etc.).
- **Both procedural and object-oriented** — you can write quick scripts procedurally or structure larger analysis pipelines using classes.

**Common Python implementations (flavors):**
| Flavor | Use case |
|---|---|
| CPython | The standard, default implementation (what "Python" means in practice) |
| PyPy | Faster execution via JIT compilation |
| Jython | Runs on the JVM, for Java interop |
| IronPython | For .NET/C# interop |

> **[Updated]** The original notes referenced Python 3.6 as "current." As of today, **Python 3.12+ is current**, and **Python 2 reached end-of-life in January 2020** — it should not be used or referenced in interviews except historically (e.g., "Python 2 had a `print` statement; Python 3 made `print()` a function").

**Interview one-liners:**
- *"Is Python compiled or interpreted?"* — Technically Python source is compiled to bytecode (`.pyc`) which then runs on the Python Virtual Machine (PVM); there's no separate manual compile step like C/Java, so it's commonly called "interpreted."
- *"Why is Python popular for data analysis?"* — Readable syntax, huge data-focused library ecosystem, strong community, integrates well with SQL/Excel/BI tools, and works well for both scripting and larger pipelines.

---

## 2. Identifiers & Reserved Words

**Identifiers** are names used for variables, functions, classes, modules, etc.

**Rules:**
1. Allowed characters: letters (a-z, A-Z), digits (0-9), and underscore (`_`). No `$` or other special symbols.
2. Cannot start with a digit (`123total` ❌, `total123` ✅).
3. Case-sensitive (`total` and `TOTAL` are different variables).
4. Cannot use a reserved keyword as an identifier.
5. No length limit, but avoid overly long names.

**Naming convention notes (important — used heavily in real code and interviews):**
- Leading single underscore `_name` → convention for "internal use" / weakly private.
- Leading double underscore `__name` → triggers **name mangling** in classes (strongly "private").
- Leading **and** trailing double underscores `__name__` → reserved for Python's own special/"magic" methods (e.g., `__init__`, `__add__`, `__str__`). Don't invent your own dunder names.

**Reserved words (keywords)** — cannot be used as identifiers. Python 3 has **35 keywords** (this grows slightly across versions; `async` and `await` were added in 3.7, and `match`/`case` are *soft* keywords added in 3.10):

```python
False, None, True, and, as, assert, async, await, break, class, continue,
def, del, elif, else, except, finally, for, from, global, if, import, in,
is, lambda, nonlocal, not, or, pass, raise, return, try, while, with, yield
```

Check the current list programmatically (this is a good habit to show in interviews — don't memorize stale counts):
```python
import keyword
print(keyword.kwlist)
print(len(keyword.kwlist))
```

> **[Updated]** The original notes state "33 reserved words." This number has changed across Python versions (`async`/`await` became full keywords in Python 3.7). Always verify with `keyword.kwlist` rather than quoting a fixed number in an interview.

---

## 3. Data Types

Python is dynamically typed — type is determined automatically from the assigned value. Built-in data types:

| Category | Types |
|---|---|
| Numeric | `int`, `float`, `complex` |
| Boolean | `bool` |
| Text | `str` |
| Binary | `bytes`, `bytearray` |
| Sequence | `list`, `tuple`, `range` |
| Set | `set`, `frozenset` |
| Mapping | `dict` |
| None | `NoneType` |

Use `type(x)` to check a variable's type and `id(x)` to get its memory address (identity).

### Numbers
- **int** — whole numbers, unlimited precision in Python 3 (no separate `long` type like Python 2 had).
  - **[Deprioritized]** Can technically be written in binary (`0b1010`), octal (`0o12`), or hexadecimal (`0xA`), with `bin()`/`oct()`/`hex()` to convert. This is trivia for a Data Analyst interview — know decimal is the default and move on; don't spend time on the other bases.
- **float** — decimal numbers; can also be written in exponential/scientific notation: `1.2e3` → `1200.0`.
- **complex** — form `a + bj`; access parts with `.real` and `.imag`. **[Deprioritized]** Rare in data-analyst work; know it exists, skip the details.

### bool
- Only `True` and `False`. Internally, `True == 1` and `False == 0` (so `True + True == 2` works).
- **Interview-relevant:** `bool()` on any value follows "truthiness" rules — `0`, `0.0`, `""`, `[]`, `{}`, `set()`, `None` are all falsy; everything else is truthy. This comes up constantly when writing `if` conditions on data (e.g., `if not df.empty:`).

### str
- Sequence of characters; immutable.
- Single, double, or triple quotes (`'''...'''` / `"""..."""` for multi-line strings or docstrings).
- Zero-based indexing, supports negative indices and slicing (`s[1:4]`, `s[::-1]` for reverse).

### bytes / bytearray — low priority
Represent raw binary data (values 0–255 each); `bytes` is immutable, `bytearray` is mutable. **[Deprioritized]** You'll see `open(file, 'rb')` for binary file reads occasionally, but deep knowledge of these types is rarely tested for a Data Analyst role — a one-line "they exist for binary/encoded data" is enough.

### range
- Represents a lazy sequence of numbers: `range(start, stop, step)`. Memory-efficient — doesn't store all values, generates them on demand.
- Used constantly in `for i in range(n):` loops.

### None
- Represents "no value." Python's equivalent of `null`. A function with no explicit `return` returns `None`.

### Immutability — a favorite interview topic
All of `int`, `float`, `complex`, `bool`, `str`, `tuple`, `frozenset`, `bytes` are **immutable** — once created, their content cannot change; any "modification" creates a new object.
`list`, `dict`, `set`, `bytearray` are **mutable**.

```python
a = 10
b = 10
a is b   # True — small ints are cached/interned by CPython, so both names point to the same object
```

> **Interview tip:** Be ready to explain `is` (identity — same object in memory) vs `==` (equality — same value). This trips up a lot of candidates.

---

## 4. Type Casting

Converting one type to another using built-in functions:

```python
int(x)      # to int
float(x)    # to float
complex(x)  # or complex(x, y)
bool(x)
str(x)
```

**Rules/gotchas to remember:**
- You can convert almost anything to `int`/`float` **except** `complex` (raises `TypeError`).
- Converting a string to `int`/`float` requires the string to actually represent a valid number (`int("10.5")` fails; `float("10.5")` works).
- `bool(0) == False`, `bool(any_nonzero_number) == True`; `bool("") == False`, `bool("False") == True` (any non-empty string is truthy, even the literal text `"False"` — a very common gotcha in interviews and real code when reading flags from CSV/config files).

```python
int("10")      # 10
float("10.5")  # 10.5
str(10.5)      # "10.5"
bool("False")  # True  <-- classic trap
```


---

## 5. Operators

### Arithmetic
`+  -  *  /  %  //  **`

- `/` is **true division** — always returns a `float`.
- `//` is **floor division** — returns `int` if both operands are `int`, else `float`.
- `%` is **modulo** (remainder).
- `**` is exponentiation.
- `x / 0` or `x % 0` always raises `ZeroDivisionError`.

```python
10 / 2    # 5.0
10 // 2   # 5
10.0 // 2 # 5.0
```

`+` and `*` also work on strings: `"a" + "b"` (concatenation), `"ab" * 3` (repetition). Mixing types (`"durga" + 10`) raises `TypeError` — you must explicitly cast.

### Relational / Comparison
`>  >=  <  <=  ==  !=`

- Work on numbers and strings (lexicographic comparison for strings).
- **Chaining is supported**: `10 < 20 < 30` evaluates as `(10<20) and (20<30)` → `True`.
- Comparing incompatible types (e.g., `10 > "durga"`) raises `TypeError` in Python 3 (Python 2 allowed it silently — another good "what changed" interview answer).

### Logical
`and  or  not`

- Python's `and`/`or` are **short-circuit** and return one of the actual operands, not just `True`/`False`:
```python
"" or "durga"       # "durga"
"durga" and ""       # ""
0 and 20              # 0
10 or 20              # 10
```
This "truthy value return" behavior is used a lot for setting default values: `value = user_input or "default"`.

### Bitwise — low priority for Data Analyst interviews
`&  |  ^  ~  <<  >>` — operate on `int` and `bool` only. **[Deprioritized]** These almost never come up in real analyst work or analyst-level interviews (they're far more an SDE/systems-programming topic). Know that they exist and what the symbols mean at a glance; don't spend study time memorizing shift-operator bit diagrams.

### Assignment / Compound assignment
`=  +=  -=  *=  /=  %=  //=  **=  &=  |=  ^=  >>=  <<=`

### Ternary (conditional expression)
```python
x = value_if_true if condition else value_if_false
```
Very commonly used for concise conditional column creation in Pandas-style logic, e.g. `label = "high" if score > 80 else "low"`.

### Identity vs Equality — classic interview question
```python
a = "durga"
b = "durga"
a is b     # identity: same object in memory?
a == b     # equality: same value/content?
```
- `is` compares memory addresses (`id()`), `==` compares values.
- CPython caches/interns small integers and short strings, so `is` can sometimes appear `True` for equal values — **never rely on `is` for value comparison**, especially with numbers, strings, or (very important for analysts) checking `x is None` — which IS the correct idiomatic use of `is` (`if x is None:` rather than `if x == None:`).

### Membership operators
`in`, `not in` — check presence in a string, list, tuple, set, or dict (checks keys for dict). Extremely common in data cleaning code:
```python
"error" in log_line
column_name not in df.columns
```

### Operator precedence (high → low, abbreviated)
`()` → `**` → unary `-`/`~` → `*, /, %, //` → `+, -` → shift → `&` → `^` → `|` → comparisons → `is`/`in` → `not` → `and` → `or`

> **Tip:** Use parentheses liberally in real code and interviews — precedence memorization matters less than writing unambiguous, readable expressions (this is also a PEP 8 best practice).

### `math` module quick reference
```python
import math
math.sqrt(16)      # 4.0
math.ceil(x); math.floor(x); math.trunc(x)
math.factorial(x)
math.gcd(x, y)
math.pi; math.e; math.inf; math.nan
```
Import styles:
```python
import math
import math as m
from math import sqrt, pi
```
> Note: `from math import *` (import everything) works but is discouraged in real code — it pollutes the namespace and makes it unclear where a name came from. Prefer explicit imports.


---

## 6. Input / Output & String Formatting

### Reading input
```python
x = input("Enter value: ")   # ALWAYS returns a str, regardless of what's typed
```
> **[Updated]** Python 2 had two functions, `input()` and `raw_input()`. Python 2's `raw_input()` became Python 3's single `input()`, and Python 2's `input()` (which evaluated the typed expression) is gone. If you only know Python 3, there's just **one** `input()` and it always returns a string — you must cast explicitly:
```python
x = int(input("Enter a number: "))
a, b = [int(v) for v in input("Enter 2 numbers: ").split()]      # split by whitespace
a, b, c = [float(v) for v in input("Enter values: ").split(',')]  # split by comma
```

`eval()` can evaluate a typed expression or literal (`eval("10+20")` → `30`, or parse a typed list/dict). **Caution:** `eval()` executes arbitrary code — never use it on untrusted input (a real security concern, worth mentioning if asked about safe input handling).

### Command-line arguments
```python
from sys import argv
print(len(argv))     # argv[0] is the script name itself, NOT the first real argument
print(argv[1])        # first actual argument
```
> **[Updated]** For any real script with multiple options/flags, use the standard `argparse` module instead of manually parsing `sys.argv` — it's the professional standard and handles help text, defaults, and type conversion for you.

### Output — `print()`
```python
print()                                  # blank line
print("Hello", "World")                  # space-separated by default
print(a, b, c, sep=',')                  # custom separator
print("Hello", end=' ')                  # custom line ending (default is '\n')
print([10, 20, 30])                       # works directly with lists/tuples/dicts
```

### String formatting — three approaches (know all three; use the third in real code)

**1. Old %-style (legacy, still seen in older codebases):**
```python
print("Value is %d" % a)
print("%s scored %d" % (name, score))
```

**2. `.format()` method:**
```python
print("Hello {0}, salary {1}".format(name, salary))
print("Hello {n}, salary {s}".format(n=name, s=salary))
```

**3. f-strings (Python 3.6+) — the modern standard, use this by default:** **[Added — not in the original notes, which predate widespread f-string adoption]**
```python
name, salary = "Durga", 10000
print(f"Hello {name}, your salary is {salary}")
print(f"Total: {price * qty:.2f}")     # inline formatting, e.g. 2 decimal places
print(f"{value=}")                       # debug shortcut (3.8+): prints "value=123"
```
f-strings are faster, more readable, and support inline expressions and formatting specs (`:.2f`, `:,`, `:>10`, etc.) — this is what you should default to in real analyst scripts (e.g. building dynamic SQL queries or log messages, formatting numbers for reports).


---

## 7. Flow Control

Flow control = the order in which statements execute. Three categories: **conditional** (`if`/`elif`/`else`), **iterative** (`for`, `while`), **transfer** (`break`, `continue`, `pass`).

### Conditional statements
```python
if condition:
    ...
elif condition2:
    ...
else:
    ...
```
- `else` is always optional.
- **Python has no `switch`/`case` statement** in the classic sense. (For long `if/elif` chains, Python 3.10+ added `match`/`case` — see below.)
- No braces — indentation defines blocks. **This is a very common early interview/practical question:** *"How does Python define code blocks?"* → via consistent indentation (4 spaces is the PEP 8 standard), not `{}`.

**[Added] `match` / `case` (Python 3.10+, structural pattern matching)** — worth knowing exists, even if `if/elif` is still more common in day-to-day analyst scripts:
```python
match status_code:
    case 200:
        print("OK")
    case 404 | 500:
        print("Error")
    case _:
        print("Unknown")
```

### Iterative statements

**`for` loop** — iterates over a sequence (string, list, tuple, dict, set, range, or any iterable):
```python
for x in "hello":
    print(x)

for i in range(10):        # 0 to 9
    print(i)

for i in range(10, 0, -1): # countdown
    print(i)
```

**`while` loop** — repeats as long as a condition is true:
```python
i = 1
while i <= 10:
    print(i)
    i += 1
```

**`for` vs `while` — quick interview answer:** use `for` when iterating over a known sequence/collection; use `while` when repeating until a condition changes (unknown number of iterations).

### Transfer statements

- **`break`** — exits the loop entirely.
- **`continue`** — skips to the next iteration.
- **`pass`** — a no-op placeholder, used where syntax requires a statement but you don't want to do anything yet (e.g., stubbing out a function during development).

```python
for item in cart:
    if item >= 500:
        print("Cannot process:", item)
        continue
    print(item)
```

**`else` on loops (a Python-specific feature many miss):**
The `else` block on a `for`/`while` loop runs **only if the loop completed without hitting a `break`**. Common use: searching for something and taking a fallback action only if not found.
```python
for item in cart:
    if item >= 500:
        print("Order blocked")
        break
    print(item)
else:
    print("All items processed successfully")   # only runs if no break occurred
```

### `del` vs assigning `None` — interview favorite
```python
x = 10
del x
print(x)      # NameError: name 'x' is not defined  -> variable no longer exists

y = 10
y = None
print(y)      # None  -> variable still exists, now points to None; old object becomes garbage-collectable
```
`del` unbinds the name entirely; assigning `None` just rebinds the name to a different object. Both make the *original* object eligible for garbage collection if nothing else references it.


---

## 8. Strings

Strings are a sequence of characters, always **immutable** — every "modifying" method returns a **new** string, never changes the original in-place. Python has no separate `char` type — a single character is just a length-1 `str`.

### Creating strings
```python
s = 'durga'
s = "durga"
s = '''multi
line'''
s = """multi
line"""
```

### Indexing & slicing (core, high-frequency interview + real-world topic)
```python
s = "durga"
s[0]       # 'd'  (positive index, left to right)
s[-1]      # 'a'  (negative index, right to left)
s[10]      # IndexError

s[1:7]     # slice: begin (inclusive) to end (exclusive)
s[:4]      # from start
s[4:]      # to end
s[::-1]    # reverse the string — very commonly asked
s[::2]     # every 2nd character
```
Out-of-range slice indices don't raise an error (unlike direct indexing) — Python just clips to what's available.

### Common string methods (used constantly in real data cleaning work)

| Category | Methods |
|---|---|
| Whitespace | `strip()`, `lstrip()`, `rstrip()` |
| Case | `upper()`, `lower()`, `title()`, `capitalize()`, `swapcase()` |
| Search | `find()`, `rfind()` (returns `-1` if not found), `index()`, `rindex()` (raises `ValueError` if not found), `count()` |
| Test | `isalnum()`, `isalpha()`, `isdigit()`, `islower()`, `isupper()`, `istitle()`, `isspace()` |
| Transform | `replace(old, new)`, `split(sep)`, `join(iterable)`, `startswith()`, `endswith()` |

```python
"  hello  ".strip()                    # "hello"
"Learning Python".replace("Python", "SQL")
"a,b,c".split(",")                     # ['a', 'b', 'c']
"-".join(["a", "b", "c"])              # "a-b-c"
"error" in log_line                    # membership check
```

> **[Added — very relevant for data cleaning]** These four are the ones you'll use *most* on real messy data: `.strip()` to clean whitespace from scraped/CSV data, `.split()`/`.join()` for parsing delimited fields, `.replace()` for fixing inconsistent values, and `.lower()`/`.upper()` for case-insensitive matching/deduplication.

### `find()` vs `index()`
Both find a substring's position. `find()` returns `-1` if not found; `index()` raises `ValueError` — pick based on whether "not found" is an expected case (use `find`) or truly exceptional (use `index`, often with `try/except`).

### String formatting recap (see §6 for detail) — prefer f-strings:
```python
f"{name}'s salary is {salary}"
f"{price:.2f}"     # 2 decimal places — common for currency/metrics in reports
f"{count:,}"        # thousands separator — e.g. 1,234,567
```

### `chr()` and `ord()`
```python
ord('a')   # 97 — character to its Unicode code point
chr(97)    # 'a' — code point to character
```
Occasionally useful for encoding tricks or Caesar-cipher-style string manipulation questions.

### Immutability proof (interview favorite)
```python
s = "abab"
s1 = s.replace("a", "b")
id(s) == id(s1)     # False — a new object was created; s itself never changed
```

### Classic string coding-interview questions (all solvable with the tools above)
- Reverse a string: `s[::-1]`
- Check if a string is a palindrome: `s == s[::-1]`
- Reverse the order of words: `' '.join(s.split()[::-1])`
- Count occurrences of each character: use a `dict` (see §12) or `collections.Counter` (see §14).
- Remove duplicate characters while preserving order: iterate and build a list of "seen" chars.
- Check for anagram: `sorted(s1) == sorted(s2)`.


---

## 9. Lists

The most-used data structure in day-to-day Python work.

**Properties:** ordered (insertion order preserved), mutable, allows duplicates, allows heterogeneous types, dynamic (growable).

```python
l = []                          # empty list
l = [10, 20, 30]
l = list(range(0, 10, 2))       # from range
l = list("durga")               # from string -> ['d','u','r','g','a']
l = "a b c".split()             # from split
```

### Indexing & slicing — same rules as strings (see §8). Negative indices, `[start:stop:step]`, out-of-range slices don't error.

### Key list methods

| Purpose | Method | Notes |
|---|---|---|
| Add to end | `append(x)` | adds a single item |
| Insert at position | `insert(i, x)` | out-of-range index clamps to start/end, doesn't error |
| Merge another iterable in | `extend(iterable)` | adds each element, not the object itself — a common gotcha: `extend("abc")` adds `'a','b','c'` as three items |
| Remove by value | `remove(x)` | removes **first** match; `ValueError` if not found |
| Remove by index (and return it) | `pop(i)` / `pop()` | `pop()` with no arg removes the **last** element; `IndexError` if list empty |
| Clear all | `clear()` | |
| Find position | `index(x)` | `ValueError` if not found — check with `in` first |
| Count occurrences | `count(x)` | |
| Sort in place | `sort()` / `sort(reverse=True)` | mixed incompatible types → `TypeError` |
| Sort by custom rule | `sort(key=func)` | e.g. `l.sort(key=len)` |
| Reverse in place | `reverse()` | |
| Non-mutating sort (returns new list) | `sorted(l)` | use this over `.sort()` when you need the original preserved |
| Duplicate the list | `copy()` or `l[:]` | see aliasing/cloning below |

```python
cart = ["Chicken", "Mutton"]
cart.append("Fish")             # ['Chicken', 'Mutton', 'Fish']
cart.extend(["RC", "KF"])       # adds both items
cart.remove("Mutton")
last = cart.pop()               # removes & returns last item — classic stack (LIFO) pattern
```

### `append()` vs `extend()` — very common interview question
- `append(x)` adds `x` as a **single** element (even if `x` is a list, you get a nested list).
- `extend(iterable)` adds each element of the iterable individually.
```python
[1, 2].append([3, 4])   # [1, 2, [3, 4]]
[1, 2].extend([3, 4])   # [1, 2, 3, 4]
```

### `remove()` vs `pop()` — another common interview question
| | `remove(x)` | `pop(i)` |
|---|---|---|
| Removes by | value | index (default: last) |
| Returns | nothing | the removed element |
| If not found/empty | `ValueError` | `IndexError` |

### Aliasing vs Cloning — very important, real bugs come from this
```python
x = [10, 20, 30]
y = x            # ALIASING: y and x point to the SAME object
y[0] = 999
print(x)         # [999, 20, 30] -- x changed too!

y = x.copy()     # or x[:]  -- CLONING: an independent copy
y[0] = 1
print(x)         # unaffected
```
`=` creates an alias (another name for the same object); `.copy()` or slicing `[:]` creates a shallow clone. This is directly related to §26 (mutable/immutable & shallow/deep copy) — a very common real bug when passing lists into functions or reusing them across loop iterations.

### List + comparison operators
```python
[10, 20] + [30, 40]     # concatenation -> [10, 20, 30, 40]
[10, 20] * 2             # repetition -> [10, 20, 10, 20]
[1, 2, 3] == [1, 2, 3]   # True — compares length, order, and content
```
Relational operators (`<`, `>`) compare lists element-by-element (lexicographically), like comparing words in a dictionary.

### Nested lists / matrices
```python
matrix = [[10, 20, 30], [40, 50, 60], [70, 80, 90]]
matrix[1][2]          # 60 — row 1, column 2
for row in matrix:
    for val in row:
        print(val, end=' ')
```
This is how you'd represent tabular/grid data with plain Python before reaching for NumPy/Pandas — good to understand conceptually even though you'll use Pandas DataFrames for real tabular work.

> List comprehensions (a very high-value topic for Data Analyst interviews) are covered together with dict/set comprehensions in **§13**.


---

## 10. Tuples

A tuple is like a list, but **immutable** — a "read-only list." Ordered, allows duplicates and heterogeneous types.

```python
t = (10, 20, 30)
t = 10, 20, 30           # parentheses are optional
t = ()                    # empty tuple
t = (10,)                 # single-element tuple — the trailing comma is MANDATORY
                           # (10) without a comma is just an int in parentheses, not a tuple!
```

> **Interview trap:** `t = (10)` → `type(t)` is `int`, not `tuple`. You need `t = (10,)`.

**Common methods:** `count()`, `index()` — that's essentially it (no `append`/`remove`/`sort`, since it's immutable). Use the built-in `sorted(t)` to get a *new sorted list* from a tuple without mutating it.

### Tuple packing / unpacking — used constantly in real code
```python
t = 10, 20, 30                # packing
a, b, c = t                    # unpacking — count must match, else ValueError

# Extended unpacking (Python 3+):
first, *rest = [1, 2, 3, 4]   # first=1, rest=[2, 3, 4]
a, *middle, last = [1, 2, 3, 4, 5]   # a=1, middle=[2,3,4], last=5
```
This is exactly how functions return multiple values in Python, and how you commonly unpack rows/tuples when iterating with `dict.items()` or `zip()`.

### List vs Tuple — high-frequency interview question
| | List | Tuple |
|---|---|---|
| Mutable | Yes | No |
| Syntax | `[ ]` | `( )` (optional) |
| Use case | Data that changes | Fixed/constant data |
| Can be a dict key | No (unhashable) | Yes (if all elements are themselves hashable) |
| Performance | Slightly slower | Slightly faster, less memory |

> **Why does this matter for analysts?** Tuples are the natural choice for fixed records (e.g., a single database row, coordinate pairs, function return values) and for dict keys when you need a composite key (e.g., `{(year, month): total_sales}`).

> **[Updated]** The original notes mention `cmp()` for comparing tuples — **`cmp()` doesn't exist in Python 3.** Just use `==`, `<`, `>` directly, or `sorted()`/`min()`/`max()`.

---

## 11. Sets

A set represents a group of **unique**, unordered values.

**Properties:** no duplicates, insertion order not preserved, mutable, heterogeneous elements allowed, no indexing/slicing.

```python
s = {10, 20, 30}
s = set([10, 20, 10, 30])     # dedupe a list -> {10, 20, 30}
s = set()                       # empty set — {} creates a dict, NOT an empty set!
```

> **Gotcha:** `{}` is an empty **dict**, not an empty set. Always use `set()` for an empty set.

### Key set methods
| Method | Purpose |
|---|---|
| `add(x)` | add one element |
| `update(iterable, ...)` | add elements from one or more iterables |
| `remove(x)` | remove element; `KeyError` if not present |
| `discard(x)` | remove element; **no error** if not present |
| `pop()` | remove & return an arbitrary element |
| `clear()` | remove all elements |
| `copy()` | shallow clone |

### Set algebra — the #1 real-world reason to use sets (deduplication, comparisons)
```python
x = {10, 20, 30, 40}
y = {30, 40, 50, 60}

x | y   # union()               -> {10,20,30,40,50,60}
x & y   # intersection()        -> {30,40}
x - y   # difference()          -> {10,20}  (in x but not y)
x ^ y   # symmetric_difference()-> {10,20,50,60}  (in either, not both)
```

> **[Added — extremely common real analyst use case]** Sets are the standard way to compare two lists of IDs/customers/columns:
```python
old_customers = set(df_old['customer_id'])
new_customers = set(df_new['customer_id'])

churned = old_customers - new_customers    # in old, not new
acquired = new_customers - old_customers   # in new, not old
retained = old_customers & new_customers   # in both
```

### `remove()` vs `discard()` vs `pop()` — interview favorite
| | On missing element | Removes |
|---|---|---|
| `remove(x)` | `KeyError` | specific value |
| `discard(x)` | no error (silent) | specific value |
| `pop()` | `KeyError` if empty | arbitrary element (sets are unordered) |

### `frozenset`
An immutable version of `set` — no `add`/`remove`. Useful as a dict key or set element when you need a "set of sets."


---

## 12. Dictionaries

A dict stores **key-value pairs**. Extremely important for analysts — this is the mental model behind JSON, API responses, and grouped/aggregated data before it becomes a DataFrame.

**Properties:** mutable, keys must be unique & hashable (immutable types like `str`, `int`, `tuple`), values can be duplicated and any type. **As of Python 3.7, dicts preserve insertion order** (this was an implementation detail in 3.6, made an official language guarantee in 3.7) — an important update from the original notes, which say order is "not preserved."

```python
d = {}                                    # empty dict
d = {100: 'durga', 200: 'ravi'}
d = dict(a=1, b=2)
d = dict([(100, 'durga'), (200, 'ravi')])  # from list of tuples
```

### Access, update, delete
```python
d[100]                 # KeyError if missing
d.get(100)              # None if missing (safe access)
d.get(100, "default")   # fallback value if missing — very common pattern

d[400] = "pavan"        # add new key, or overwrite existing key
del d[100]               # remove a key — KeyError if missing
d.pop(100)               # remove & RETURN the value — KeyError if missing
d.pop(100, None)         # safe pop with default
d.popitem()              # remove & return an arbitrary (in 3.7+, the LAST inserted) key-value pair
d.clear()
```

> **[Updated]** `has_key()` was a Python 2 method and **no longer exists in Python 3**. Always use `key in d` to check for membership.

### Iterating a dict
```python
d.keys()      # dict_keys view
d.values()    # dict_values view
d.items()     # dict_items view -> (key, value) tuples

for k, v in d.items():
    print(k, v)
```

### `get()` vs `[]` — very common interview/practical question
`d[key]` raises `KeyError` on a missing key; `d.get(key, default)` returns a fallback instead. Prefer `.get()` whenever a missing key is a normal, expected case (e.g., counting occurrences, optional config values).

### `setdefault()`
```python
d.setdefault(key, value)
```
Returns the existing value if `key` is present; otherwise inserts `key: value` and returns `value`. Handy for building "group into lists" structures in one line:
```python
groups = {}
for name, dept in records:
    groups.setdefault(dept, []).append(name)
```

### Counting pattern — a classic interview question, and the "manual" version of `Counter`
```python
word = "mississippi"
counts = {}
for ch in word:
    counts[ch] = counts.get(ch, 0) + 1
```
(See §14 for the shortcut using `collections.Counter`.)

### Dict comprehension — covered fully in §13
```python
squares = {x: x*x for x in range(1, 6)}
```


---

## 13. Comprehensions [Added]

Comprehensions are one of the **most-asked topics in Python interviews** for any data role — they're the concise, "Pythonic" alternative to writing manual `for` loops to build a new collection. The original notes scattered these across list/set/dict chapters; consolidated here for quick review.

### List comprehension
```python
squares = [x*x for x in range(1, 11)]
evens = [x for x in squares if x % 2 == 0]           # with filter condition
initials = [name[0] for name in ["Ravi", "Sunny"]]     # transform each element
```
General syntax: `[expression for item in iterable if condition]`

### Set comprehension
```python
unique_lengths = {len(word) for word in ["cat", "dog", "goat"]}
```

### Dict comprehension
```python
squares = {x: x*x for x in range(1, 6)}
inverted = {v: k for k, v in original_dict.items()}    # swap keys and values
```

### Generator expression (looks like a comprehension but lazy — see §17)
```python
gen = (x*x for x in range(1, 6))    # NOT a tuple! Tuples have no comprehension syntax.
```
> **Interview trap:** There's no such thing as a "tuple comprehension." `(x for x in range(5))` creates a **generator object**, not a tuple. To get an actual tuple: `tuple(x for x in range(5))`.

### Nested comprehension (flatten a list of lists)
```python
matrix = [[1, 2], [3, 4], [5, 6]]
flat = [num for row in matrix for num in row]     # [1, 2, 3, 4, 5, 6]
```

### Why this matters for Data Analysts
Comprehensions are the everyday, Pythonic replacement for writing `for` loops to filter/transform data before it even reaches Pandas — e.g., cleaning a list of column names, quick filtering, or building lookup dictionaries. Interviewers frequently ask you to rewrite a `for` loop as a comprehension (or vice versa) to test fluency.

**Readability rule of thumb:** if a comprehension needs more than one `for` or more than one `if`, or the expression gets hard to read on one line, switch back to a regular loop — comprehensions should improve clarity, not hurt it.


---

## 14. Functions

A function is a reusable named block of code. `def` is mandatory to define one; `return` is optional (a function with no `return` returns `None`).

```python
def wish(name):
    print("Hello", name)

def add(x, y):
    return x + y

result = add(10, 20)
```

### Returning multiple values — Python-specific strength
Unlike C/Java/most statically-typed languages, a Python function can return multiple values at once (they're packed into a tuple and can be unpacked directly):
```python
def calc(a, b):
    return a+b, a-b, a*b, a/b

total, diff, prod, quot = calc(100, 50)
```
This is genuinely useful in analyst work — e.g. a function that returns both a cleaned DataFrame and a log of what was changed.

### Function vs Module vs Library — quick mental model
- **Function** = a named block of reusable code.
- **Module** = a `.py` file containing functions/classes/variables.
- **Package/Library** = a collection of modules (a folder with an `__init__.py`, or a published library like Pandas).

### Variable scope: Global vs Local
```python
a = 10                 # global

def f1():
    print(a)            # can READ global a

def f2():
    a = 777              # this creates a NEW local variable a, doesn't touch global a
    print(a)

def f3():
    global a
    a = 777              # this DOES modify the global a
```
- A variable assigned anywhere inside a function is treated as **local** to that function unless declared `global`.
- **`global`** keyword lets a function modify a module-level variable.
- **`nonlocal`** (not always covered in older notes) does the equivalent for enclosing (outer) function scope in nested functions — used with closures.

> **Interview tip:** "What's the difference between local and global scope in Python?" is a very standard question — be ready to show the `f2()` vs `f3()` example above; it's the classic gotcha.

### Recursive functions
A function calling itself. Useful for tree/hierarchical data (e.g., recursively summing nested category totals) but generally used sparingly in day-to-day analyst work compared to iteration/vectorized operations.
```python
def factorial(n):
    return 1 if n == 0 else n * factorial(n - 1)
```
Watch for **maximum recursion depth** — Python's default recursion limit is ~1000; deep recursion (e.g., over a huge unbounded dataset) will hit `RecursionError`, so an iterative approach is often safer for large data.

### Functions are objects — Python-specific concept, occasionally asked
Functions can be assigned to variables ("aliased"), passed as arguments, and returned from other functions — this is what makes decorators (§18), `map`/`filter`/`reduce` (§16), and callbacks possible.
```python
def wish(name):
    print("Hello", name)

greet = wish        # aliasing — same function, another name
greet("Durga")
```

### Nested functions & closures
```python
def outer():
    def inner():
        print("inner running")
    return inner   # returning a function object

f = outer()
f()   # calls inner
```
This pattern (a function returning another function that "remembers" its enclosing scope) is called a **closure** — the foundation of how decorators work.


---

## 15. *args, **kwargs and Scope [Added/Expanded]

### Types of function arguments
Python supports four ways to pass arguments:

**1. Positional arguments** — matched to parameters by order.
```python
def sub(a, b): print(a - b)
sub(100, 200)
```

**2. Keyword arguments** — matched by parameter name, order doesn't matter.
```python
def wish(name, msg): print("Hello", name, msg)
wish(msg="Good Morning", name="Durga")
```
Positional args must come before keyword args in a call, or you get a `SyntaxError`.

**3. Default arguments** — a fallback value if the caller doesn't provide one.
```python
def wish(name="Guest"): print("Hello", name)
wish()          # Hello Guest
wish("Durga")   # Hello Durga
```
> Rule: once you use a default argument in the signature, every parameter after it must also have a default (`def f(a, b="x", c)` is invalid — `c` needs a default too, or must come before `b`).

**4. Variable-length arguments — `*args` and `**kwargs`** (very commonly asked in interviews):
```python
def total(*args):            # args becomes a tuple of all positional values passed
    return sum(args)

total(10, 20, 30)   # 60
total()               # 0

def show(**kwargs):          # kwargs becomes a dict of all keyword arguments passed
    for k, v in kwargs.items():
        print(k, "=", v)

show(name="Durga", age=48)
```
- `*args` collects extra **positional** arguments into a tuple.
- `**kwargs` collects extra **keyword** arguments into a dict.
- Order in a function signature: `def f(positional, *args, default=val, **kwargs):`
- You'll see `*args, **kwargs` constantly in real-world code — especially when writing wrapper/decorator functions that need to pass through arbitrary arguments to another function (see §18).

### `*` for unpacking when *calling* a function (the reverse direction)
```python
def add(a, b, c): return a+b+c
nums = [1, 2, 3]
add(*nums)          # unpacks list into 3 positional args

d = {"a": 1, "b": 2, "c": 3}
add(**d)             # unpacks dict into keyword args
```


---

## 16. Lambda, map, filter, reduce

### `lambda` — anonymous, one-line functions
```python
square = lambda n: n * n
add = lambda a, b: a + b
biggest = lambda a, b: a if a > b else b
```
- No `return` needed — the expression's value is returned automatically.
- Meant for short, throwaway, one-time-use logic — mainly used as an inline argument to another function (`map`, `filter`, `sort(key=...)`, Pandas `.apply()`).
- If the logic needs more than one line or gets hard to read, write a normal `def` function instead — that's the professional convention (also explicitly called out in PEP 8).

### `filter()` — keep elements matching a condition
```python
nums = [0, 5, 10, 15, 20]
evens = list(filter(lambda x: x % 2 == 0, nums))   # [0, 10, 20]
```

### `map()` — transform every element
```python
nums = [1, 2, 3, 4]
doubled = list(map(lambda x: x * 2, nums))          # [2, 4, 6, 8]

# map() across multiple lists in parallel:
l1, l2 = [1, 2, 3], [10, 20, 30]
products = list(map(lambda x, y: x * y, l1, l2))    # [10, 40, 90]
```

### `reduce()` — collapse a sequence into a single value (from `functools`)
```python
from functools import reduce
total = reduce(lambda x, y: x + y, [10, 20, 30, 40, 50])   # 150
```

### Interview note — Pythonic style
While `map()`/`filter()` are important to *know* (they come up in interviews and in some codebases), **list comprehensions are generally preferred in modern Python** for readability:
```python
evens = [x for x in nums if x % 2 == 0]     # usually preferred over filter()
doubled = [x * 2 for x in nums]              # usually preferred over map()
```
Know both — be able to write either, and be ready to explain that comprehensions are typically considered more "Pythonic" for simple cases, while `map`/`filter`/`reduce` remain useful for functional-style pipelines or when passing an already-defined function.


---

## 17. Iterators & Generators

### Iterables vs Iterators — a core conceptual interview question
- An **iterable** is anything you can loop over (`list`, `tuple`, `str`, `dict`, `set`, `range`, a generator, ...) — it has an `__iter__()` method.
- An **iterator** is the object that actually produces values one at a time via `__next__()`, and raises `StopIteration` when exhausted. `iter(some_list)` gives you an iterator over that list.
```python
l = [1, 2, 3]
it = iter(l)
next(it)   # 1
next(it)   # 2
next(it)   # 3
next(it)   # StopIteration
```
`for` loops use this machinery under the hood automatically.

### Generators
A generator is a function that **produces a sequence of values lazily**, one at a time, using `yield` instead of `return`. Each call to `next()` resumes the function right after the last `yield`.

```python
def firstn(num):
    n = 1
    while n <= num:
        yield n
        n += 1

for x in firstn(5):
    print(x)          # 1 2 3 4 5

values = firstn(10)
list(values)            # converts a generator to a list
```

```python
def fib():
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b

for f in fib():
    if f > 100:
        break
    print(f)
```

### Why generators matter enormously for Data Analysts — the #1 practical reason
**Memory efficiency.** A normal list comprehension builds the *entire* collection in memory; a generator produces values one at a time on demand.
```python
# This can raise MemoryError on a huge range:
squares = [x*x for x in range(10**16)]

# This works fine — nothing is computed until you ask for it:
squares_gen = (x*x for x in range(10**16))
next(squares_gen)   # 0 — only this one value computed so far
```
This is directly relevant when processing large files or datasets: reading a huge CSV/log file line-by-line with a generator avoids loading the whole thing into memory at once (this is conceptually the same idea behind Pandas' `chunksize` parameter when reading large files, which you'll cover in your Pandas notes).

### Generator expression syntax (parentheses, not brackets)
```python
gen = (x for x in range(5))   # generator, NOT a tuple
```


---

## 18. Decorators

A decorator is a function that takes another function as input, wraps/extends its behavior, and returns a new function — **without modifying the original function's code**. This relies on the closure concept from §14 (a function returning another function).

```python
def decor(func):
    def inner(name):
        if name == "Sunny":
            print("Hello Sunny — special case")
        else:
            func(name)
    return inner

@decor
def wish(name):
    print("Hello", name, "Good Morning")

wish("Durga")   # Hello Durga Good Morning
wish("Sunny")   # Hello Sunny — special case
```
`@decor` above `def wish(...)` is exactly equivalent to writing `wish = decor(wish)`.

### A very practical example — adding error handling without touching the original function
```python
def smart_division(func):
    def inner(a, b):
        print(f"Dividing {a} by {b}")
        if b == 0:
            print("Cannot divide by zero")
            return
        return func(a, b)
    return inner

@smart_division
def division(a, b):
    return a / b

division(20, 0)   # handled gracefully instead of raising ZeroDivisionError
```

### Decorator chaining
Multiple decorators can stack; they apply bottom-up (closest to the function first):
```python
@decor1
@decor2
def wish(name):
    ...
# equivalent to: wish = decor1(decor2(wish))
```

### Why this matters for Data Analysts
You'll rarely *write* complex decorators day-to-day, but you'll frequently **use** them — e.g., `@st.cache_data` in Streamlit dashboards, timing/logging decorators around slow data-loading functions, or retry decorators around API calls. Understanding the mechanics (a function wrapping a function) makes these tools much less mysterious, and "explain what a decorator is" is a common Python interview question at almost every level.

**[Added]** A commonly asked practical use case: writing a simple `@timer` decorator to measure how long a data-processing function takes:
```python
import time
from functools import wraps

def timer(func):
    @wraps(func)   # preserves the original function's name/docstring — good practice
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        print(f"{func.__name__} took {time.time() - start:.2f}s")
        return result
    return wrapper

@timer
def load_data(path):
    ...
```
This is exactly where `*args, **kwargs` (§15) become essential — the wrapper needs to accept and forward *any* arguments the wrapped function might take.


---

## 19. Modules & Packages

### Modules
A **module** is simply a `.py` file containing functions, variables, and classes. Any Python file can be imported as a module by another file.

```python
# durgamath.py
x = 888
def add(a, b): return a + b
```
```python
# test.py
import durgamath
print(durgamath.x)
durgamath.add(10, 20)
```

**Import styles:**
```python
import module
import module as alias
from module import member
from module import member1, member2
from module import member as alias
from module import *          # imports everything — avoid in real code, pollutes namespace
```

Once you import with an alias, use only the alias — the original name is not accessible.

### The `__name__` variable — a very common, practical interview question
Every module gets a special `__name__` variable automatically. When a file is run directly, `__name__ == "__main__"`. When it's imported by another file, `__name__` equals the module's name instead.
```python
def main():
    print("running")

if __name__ == "__main__":
    main()
```
This is the standard pattern for making a script both runnable directly *and* safely importable elsewhere (importing it won't trigger `main()` again) — you'll see this in virtually every real-world Python script, including data pipelines.

### `dir()` — introspection
```python
dir()             # members of the current module
dir(some_module)   # members of a specific module
```
Useful for quickly checking what functions/attributes an object or imported module exposes — handy when exploring an unfamiliar library interactively.

### Two standard-library modules worth knowing well

**`math`** — see §5 for the core functions (`sqrt`, `ceil`, `floor`, `factorial`, etc.)

**`random`** — used constantly for sampling, simulations, and generating test/dummy data:
```python
import random
random.random()          # random float, 0 <= x < 1
random.randint(1, 100)    # random int, INCLUSIVE of both ends
random.uniform(1, 10)     # random float, 1 <= x < 10
random.choice(my_list)    # random element from a list
random.sample(my_list, 3) # k unique random elements — [Added] very useful for creating a random test subset from a dataset
random.shuffle(my_list)   # shuffles a list in place — [Added] useful for train/test splitting by hand or randomizing row order
```

### Packages
A **package** is a folder of related modules — identified by containing an `__init__.py` file (which can be empty). Packages let you organize larger codebases and avoid naming collisions.
```
project/
  ├── test.py
  └── pack1/
        ├── __init__.py
        └── module1.py
```
```python
import pack1.module1
pack1.module1.f1()

# or
from pack1.module1 import f1
f1()
```
> **[Updated]** Since Python 3.3, `__init__.py` is technically optional for basic "namespace packages," but it's still standard practice to include it (even empty) for regular packages — this keeps behavior explicit and works across all Python 3 versions, so keep using it.

### Why this matters for analysts
You interact with this system constantly — every `import pandas as pd` or `from sklearn.model_selection import train_test_split` uses exactly this import machinery. Understanding modules/packages helps you organize your own analysis scripts into reusable pieces (e.g., a `data_cleaning.py` module you import across multiple notebooks/projects) instead of copy-pasting code.


---

## 20. File Handling (text, CSV, JSON)

### Opening and closing files
```python
f = open(filename, mode)
...
f.close()
```

| Mode | Meaning |
|---|---|
| `'r'` | read (default); `FileNotFoundError` if file doesn't exist |
| `'w'` | write; **overwrites** existing content, creates file if missing |
| `'a'` | append; doesn't overwrite, creates file if missing |
| `'r+'` | read + write, doesn't delete existing data |
| `'x'` | exclusive creation; `FileExistsError` if file already exists |
| add `'b'` | binary mode, e.g. `'rb'`, `'wb'` — for images, non-text files |

### The `with` statement — always use this in real code
```python
with open("data.txt", "r") as f:
    content = f.read()
# file is automatically closed here, even if an exception occurs
```
This is the standard, professional way to handle files — it guarantees the file gets closed even if something goes wrong mid-read, without needing an explicit `f.close()` or a `try/finally`. **Always prefer `with` over manual `open()`/`close()`** in real code.

### Reading
```python
f.read()          # entire file as one string
f.read(n)          # first n characters
f.readline()       # one line at a time
f.readlines()      # list of all lines
for line in f:     # memory-efficient line-by-line iteration — good for large files
    print(line)
```

### Writing
```python
f.write("some text\n")            # write() does NOT add a newline automatically
f.writelines(["line1\n", "line2\n"])
```

### CSV files — the format you'll touch most as a Data Analyst
```python
import csv

# Writing
with open("emp.csv", "w", newline='') as f:     # newline='' avoids extra blank rows on Windows
    writer = csv.writer(f)
    writer.writerow(["ID", "Name", "Salary"])     # header
    writer.writerow([100, "Durga", 50000])

# Reading
with open("emp.csv", "r") as f:
    reader = csv.reader(f)
    for row in reader:
        print(row)          # each row is a list of strings

# Reading as dictionaries (column name -> value) — very handy
with open("emp.csv", "r") as f:
    reader = csv.DictReader(f)
    for row in reader:
        print(row["Name"], row["Salary"])
```
> **In real analyst work, you'll almost always load CSVs with `pandas.read_csv()` instead of the raw `csv` module** — but knowing the raw `csv` module matters for interviews and for quick scripts where pulling in Pandas is overkill.

### JSON handling [Added — very common for analysts, missing from the original notes]
JSON is the standard format for API responses and config files — essential for any analyst pulling data from APIs.
```python
import json

# Python object -> JSON string
json.dumps({"name": "Durga", "scores": [90, 85]})

# Python object -> JSON file
with open("data.json", "w") as f:
    json.dump(my_dict, f, indent=2)

# JSON string -> Python object
data = json.loads('{"name": "Durga"}')

# JSON file -> Python object
with open("data.json", "r") as f:
    data = json.load(f)
```
Nested JSON (dicts inside lists inside dicts — the norm for real API responses) is navigated exactly like nested dicts/lists (§9, §12). `pandas.json_normalize()` (covered in your Pandas notes) is the standard tool for flattening nested JSON into a DataFrame.

### Checking if a file exists
```python
import os
os.path.isfile("data.csv")
```
> **[Updated]** For modern code, `pathlib` is now generally preferred over `os.path` for file/path operations — cleaner, object-oriented syntax:
```python
from pathlib import Path
Path("data.csv").exists()
Path("data.csv").is_file()
```

### `seek()` and `tell()`
`f.tell()` returns the current cursor position; `f.seek(offset)` moves the cursor. Rarely needed in analyst work but occasionally comes up for reading fixed-width files or resuming partial reads.

### Basic directory operations (`os` module)
```python
os.getcwd()             # current working directory
os.listdir(".")          # list contents of a directory (not recursive)
os.path.isfile(path)      # check file exists
os.makedirs("a/b/c")      # create nested directories
```


---

## 21. Exception Handling

### Errors vs Exceptions
- **Syntax errors** — invalid code structure, caught before the program runs. You must fix these; there's no "handling" them.
- **Runtime errors (exceptions)** — something goes wrong while the program is executing (bad input, division by zero, missing file, etc.). These *can* be handled.

### Why this matters for analysts
Exception handling is what keeps a data pipeline or ETL script from crashing entirely because of one bad row, missing file, or malformed value — instead it can log the problem and continue (or fail gracefully with a clear message). This is one of the most practically important topics for real job work, not just interviews.

### Basic syntax
```python
try:
    risky_code
except SomeException:
    handling_code
```
- Only put the code that might actually fail inside `try` — keep it as short/focused as possible.
- If an exception happens inside `try`, execution jumps immediately to a matching `except` — the rest of the `try` block is skipped, even the lines after the failing one.

```python
try:
    x = int(input("Enter a number: "))
    y = int(input("Enter another number: "))
    print(x / y)
except ZeroDivisionError:
    print("Can't divide by zero")
except ValueError:
    print("Please enter valid integers")
```

### Multiple except blocks — order matters
Python checks `except` blocks top-to-bottom and uses the **first match**. Put more specific exceptions before more general ones (e.g., `ZeroDivisionError` before its parent class `ArithmeticError`), otherwise the general one will "steal" the match and the specific one never runs.

### Catching multiple exception types in one block
```python
except (ZeroDivisionError, ValueError) as e:
    print("Problem:", e)
```

### Catch-all / default except
```python
except Exception as e:      # catches (almost) anything
    print("Something went wrong:", e)
```
> **Best practice:** avoid a bare `except:` (no exception type at all) in real code — it also catches things like `KeyboardInterrupt` and makes bugs harder to find. Prefer `except Exception as e:` if you truly need a catch-all, and log/print `e` so you can see what actually happened.

### `finally` — cleanup code that always runs
```python
try:
    ...
except ...:
    ...
finally:
    print("This always runs — exception or not, handled or not")
```
Use `finally` (or, more commonly today, a `with` block — see §20) for guaranteed cleanup: closing files, closing database connections, releasing resources.

### `else` — runs only if `try` succeeded with no exception
```python
try:
    result = risky_call()
except SomeError:
    print("failed")
else:
    print("succeeded, result:", result)   # only runs if no exception occurred
finally:
    print("cleanup")
```

### Rules worth remembering
- `except` and `finally` can't exist without a preceding `try`.
- `try` needs at least one `except` or a `finally`.
- Multiple `except` blocks are allowed per `try`; only one `finally`.
- `else` requires an `except` to be present.
- `try/except/finally` blocks can be nested.

### Built-in exception hierarchy (know the common ones)
All exceptions inherit from `BaseException`; almost everything you'll catch inherits from `Exception`.

| Exception | When it's raised |
|---|---|
| `ZeroDivisionError` | dividing by zero |
| `ValueError` | right type, invalid value (e.g. `int("abc")`) |
| `TypeError` | wrong type for an operation |
| `KeyError` | missing dict key |
| `IndexError` | out-of-range sequence index |
| `FileNotFoundError` | file doesn't exist |
| `AttributeError` | accessing an attribute/method that doesn't exist |
| `ImportError` / `ModuleNotFoundError` | import fails |
| `NameError` | using an undefined variable |
| `StopIteration` | iterator exhausted (used internally by `for` loops) |

> **Interview favorite:** *"What's the difference between `KeyError` and `IndexError`?"* — `KeyError` is for missing dict keys, `IndexError` is for out-of-range list/tuple/string indices.

### Custom (user-defined) exceptions
Define your own exception by subclassing `Exception`, and raise it with `raise`:
```python
class InsufficientFundsError(Exception):
    pass

def withdraw(balance, amount):
    if amount > balance:
        raise InsufficientFundsError(f"Cannot withdraw {amount}, balance is {balance}")
    return balance - amount
```
Useful when writing your own data-validation logic (e.g., a custom `InvalidSchemaError` when a CSV doesn't have the expected columns).

### Logging exceptions [condensed — de-prioritized for analyst work]
Python's built-in `logging` module writes structured log messages (with severity levels `DEBUG < INFO < WARNING < ERROR < CRITICAL`) to a file instead of just printing to console — the standard, professional replacement for scattering `print()` statements through a script.
```python
import logging
logging.basicConfig(filename='app.log', level=logging.INFO)
logging.info("Job started")
try:
    ...
except Exception:
    logging.exception("Job failed")   # logs the error + full traceback
```
> **[Updated]** Modern data pipelines typically configure logging once centrally (or use a framework's built-in logger, e.g. Airflow/Prefect) rather than calling `basicConfig()` in every script — worth knowing the concept exists, but treat this as background knowledge rather than something to memorize deeply for an analyst interview.

### `assert` — for development-time sanity checks, not production error handling
```python
assert condition, "error message if condition is False"
```
Raises `AssertionError` if the condition is false. Useful for catching bugs during development/testing (e.g., asserting a DataFrame has the expected number of rows after a merge) — but **assertions are typically stripped out or skipped in optimized/production runs**, so never use `assert` for handling real runtime input validation or business logic; use proper `if`/`raise` or `try/except` for that.


---

## 22. Object-Oriented Programming (OOP)

OOP is a very common interview area — even for Data Analyst roles, expect at least a few conceptual questions ("What is a class?", "Explain inheritance", "What's `self`?").

### Class & Object basics
A **class** is a blueprint; an **object** is an actual instance created from it.
```python
class Student:
    def __init__(self, name, marks):     # constructor
        self.name = name                  # instance variables
        self.marks = marks

    def display(self):                    # instance method
        print(self.name, self.marks)

s1 = Student("Durga", 90)                 # object creation
s1.display()
```

### `self`
`self` always refers to the current object (similar to `this` in Java/C++). It must be the first parameter of the constructor and every instance method — Python passes it automatically when you call `obj.method()`.

### The constructor — `__init__`
- Special method, always named `__init__`.
- Runs automatically once per object, at creation time.
- Used to declare and initialize instance variables.
- If you don't define one, Python provides an empty default constructor.

| | Method | Constructor |
|---|---|---|
| Name | any name | always `__init__` |
| Called | explicitly, by you | automatically, on object creation |
| Called how many times | any number | once per object |

### Types of variables in a class
| Type | Declared | Scope |
|---|---|---|
| **Instance variables** | `self.x = ...` (in `__init__` or any method) | separate copy per object |
| **Static/class variables** | directly inside the class, outside any method | one copy shared by **all** objects |
| **Local variables** | inside a method body (no `self.`) | exist only during that method call |

```python
class Test:
    count = 0                # static/class variable — shared
    def __init__(self):
        self.id = Test.count  # instance variable — per-object
        Test.count += 1        # modify the shared class variable via the class name
```
> **Interview trap:** modifying a mutable class-level variable (like a list) through `self.` can accidentally create a *new* instance variable that shadows the class variable instead of modifying the shared one — always use the class name (`Test.count`) to intentionally modify a class-level variable.

### Types of methods
| Type | Decorator | First param | Use when... |
|---|---|---|---|
| Instance method | none | `self` | needs access to instance (`self.x`) data — the default, most common case |
| Class method | `@classmethod` | `cls` | needs access to class-level (static) data only |
| Static method | `@staticmethod` | none | a general utility function that logically belongs in the class but touches neither instance nor class state |

```python
class Employee:
    company = "Acme"

    def __init__(self, name):
        self.name = name

    def greet(self):                     # instance method
        print(f"Hi, I'm {self.name} at {self.company}")

    @classmethod
    def change_company(cls, new_name):    # class method
        cls.company = new_name

    @staticmethod
    def is_valid_id(emp_id):              # static method
        return emp_id.isdigit()
```

### Getters and setters
```python
def set_name(self, name): self.name = name    # setter
def get_name(self): return self.name           # getter
```
Python doesn't enforce private access the way Java does — attributes are accessible directly by default, and getters/setters are used mainly by convention. (Python's actual "privacy" idiom is naming convention — leading underscore(s) — not enforced restriction; see §2.) **[Added]** For real encapsulation with validation logic, Python's idiomatic tool is the `@property` decorator:
```python
class Employee:
    def __init__(self, salary):
        self._salary = salary

    @property
    def salary(self):
        return self._salary

    @salary.setter
    def salary(self, value):
        if value < 0:
            raise ValueError("Salary can't be negative")
        self._salary = value

e = Employee(50000)
e.salary = 60000      # calls the setter automatically — looks like plain attribute access
```

### Inheritance [Expanded — the original notes only cover this indirectly under "overriding"] 
Inheritance lets a class (**child/subclass**) reuse and extend the members of another class (**parent/superclass**).

```python
class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age

class Employee(Person):          # Employee inherits from Person
    def __init__(self, name, age, salary):
        super().__init__(name, age)     # call parent constructor
        self.salary = salary
```

**Types of inheritance** (a standard interview list):
| Type | Description |
|---|---|
| Single | one child, one parent |
| Multilevel | A → B → C (chain) |
| Hierarchical | multiple children from one parent |
| Multiple | one child inherits from multiple parents — `class C(A, B):` |
| Hybrid | a combination of the above |

**`super()`** gives access to the parent class from within the child — used to call the parent's constructor or an overridden method:
```python
class C(P):
    def marry(self):
        super().marry()       # call the parent's version too
        print("Katrina Kaif")
```

**Method Resolution Order (MRO)** — for multiple inheritance, Python decides which parent's method to use following a defined order (C3 linearization). You can inspect it with `ClassName.__mro__` or `ClassName.mro()`. Rarely needs deep understanding for an analyst interview, but knowing it exists (and that Python resolves ambiguity in multiple inheritance predictably, not arbitrarily) is a good "I know this is a thing" answer.

### Polymorphism
"Many forms" — the same interface behaving differently depending on context.
- `+` acting as both addition and string concatenation is a simple built-in example.
- **Duck typing**: Python doesn't check an object's type before calling a method — if the object has that method, it works ("if it walks like a duck and talks like a duck, it's a duck"). This is central to how Python's dynamic typing works in practice.
```python
def make_it_talk(obj):
    obj.talk()   # works for ANY object that has a talk() method, regardless of class
```

### Overloading vs Overriding — very common interview question
| | Overloading | Overriding |
|---|---|---|
| Meaning | same name, different signature | child redefines a parent's method |
| Supported in Python? | **Not natively** — Python keeps only the *last* defined version of a same-named method | **Yes**, fully supported — core to inheritance |
| How Python fakes overloading | default arguments or `*args`/`**kwargs` | n/a |

```python
# "Overloading" the Python way — via default args:
def total(self, a=None, b=None, c=None):
    ...

# Overriding — completely normal and common:
class P:
    def marry(self): print("Parent's choice")

class C(P):
    def marry(self): print("Child's own choice")   # overrides parent's version
```

### Operator overloading — via "magic"/"dunder" methods
Python operators map to special methods you can override in your own classes:

| Operator | Magic method |
|---|---|
| `+` | `__add__(self, other)` |
| `-` | `__sub__` |
| `*` | `__mul__` |
| `==` | `__eq__` |
| `<`, `>`, `<=`, `>=` | `__lt__`, `__gt__`, `__le__`, `__ge__` |
| `str(obj)` | `__str__` |
| `len(obj)` | `__len__` |

```python
class Book:
    def __init__(self, pages):
        self.pages = pages
    def __add__(self, other):
        return self.pages + other.pages

b1, b2 = Book(100), Book(200)
b1 + b2     # 300 — invokes __add__ automatically
```
`__init__` (constructor) and `__str__`/`__repr__` (string representation, used by `print()`) are the two dunder methods you'll define most often in practice.

### Garbage collection & destructors [condensed]
Python automatically destroys objects that no longer have any references pointing to them (reference counting, plus a cyclic garbage collector for reference cycles) — you don't manage memory manually like in C/C++. `__del__(self)` is a destructor hook for cleanup, but relying on it is discouraged in modern code — prefer explicit cleanup with `with` blocks (context managers) or `try/finally` (see §20, §21) since `__del__`'s exact timing isn't guaranteed.


---

## 23. Regular Expressions

Regex is one of the **highest-value skills for a Data Analyst** — used constantly for data cleaning, validation, and extraction (phone numbers, emails, IDs, log parsing) before/alongside Pandas `.str.contains()`, `.str.extract()`, `.str.replace()` (which all accept regex patterns under the hood).

### The `re` module — core functions
```python
import re

re.search(pattern, text)     # find FIRST match anywhere in the string; None if no match
re.match(pattern, text)       # match only at the START of the string
re.fullmatch(pattern, text)   # the ENTIRE string must match
re.findall(pattern, text)     # returns a LIST of all matches
re.finditer(pattern, text)    # returns an ITERATOR of Match objects (has .start(), .end(), .group())
re.sub(pattern, repl, text)   # substitute all matches with repl
re.split(pattern, text)       # split a string by a regex pattern
```

### `search()` vs `match()` vs `fullmatch()` — a common interview question
| Function | Matches... |
|---|---|
| `match()` | only at the **beginning** of the string |
| `search()` | **anywhere** in the string (first occurrence) |
| `fullmatch()` | the **entire** string, start to end |

### Character classes
```python
[abc]        # a or b or c
[^abc]       # NOT a, b, or c
[a-z]        # any lowercase letter
[A-Z]        # any uppercase letter
[0-9]        # any digit
[a-zA-Z0-9]  # any alphanumeric character
```

### Predefined shortcuts
| Pattern | Meaning |
|---|---|
| `\d` | any digit — same as `[0-9]` |
| `\D` | any non-digit |
| `\w` | any "word" character — letters, digits, underscore |
| `\W` | any non-word character |
| `\s` | any whitespace |
| `\S` | any non-whitespace |
| `.` | any character (except newline) |

### Quantifiers
| Pattern | Meaning |
|---|---|
| `a+` | one or more `a` |
| `a*` | zero or more `a` |
| `a?` | zero or one `a` (optional) |
| `a{3}` | exactly 3 `a`s |
| `a{2,4}` | between 2 and 4 `a`s |

### Anchors
```python
^text     # string must START with "text"
text$     # string must END with "text"
```

### Practical, high-frequency patterns
```python
# Validate a 10-digit mobile number starting with 7, 8, or 9
re.fullmatch(r"[7-9]\d{9}", number)

# Extract all mobile numbers from a block of text
re.findall(r"[7-9]\d{9}", text)

# Basic email validation
re.fullmatch(r"[\w.]+@[\w]+\.[a-zA-Z]{2,}", email)

# Case-insensitive match
re.search(r"easy$", text, re.IGNORECASE)

# Replace all digits with '#'
re.sub(r"\d", "#", text)
```

### Match object methods
```python
m = re.search(r"\d+", "order id 4523")
m.group()   # matched text: '4523'
m.start()   # start index
m.end()     # end index
```

### `sub()` vs `subn()`
Both replace matches; `subn()` additionally returns the count of replacements as `(result_string, count)`.

> **[Added] For Data Analyst work specifically:** you'll mostly apply regex *through* Pandas string methods rather than the raw `re` module:
```python
df['phone'].str.match(r"[7-9]\d{9}")             # boolean mask
df['email'].str.extract(r"(\w+)@")                # extract username part
df['text'].str.replace(r"\s+", " ", regex=True)   # collapse multiple spaces
```
Still, knowing raw `re` syntax is essential — the pattern syntax is identical whether you call it via `re.search()` or `df['col'].str.contains()`, and interviewers commonly ask you to write a regex pattern from scratch on a whiteboard.

**Use `r"..."` (raw strings) for regex patterns** — avoids issues where `\d`, `\w`, etc. could otherwise be misread as string escape sequences.


---

## 24. Dates & Times [Added]

Not covered in the original notes at all, but essential for virtually any real dataset (time series, timestamps, log files, transaction dates).

### The `datetime` module
```python
from datetime import datetime, date, timedelta

now = datetime.now()               # current date & time
today = date.today()                # current date only

d = datetime(2024, 3, 15, 14, 30)   # specific date/time: year, month, day, hour, minute

# Formatting a datetime as a string
d.strftime("%Y-%m-%d")              # '2024-03-15'
d.strftime("%d/%m/%Y %H:%M")        # '15/03/2024 14:30'

# Parsing a string into a datetime
datetime.strptime("15-03-2024", "%d-%m-%Y")
```

### Common format codes
| Code | Meaning | Example |
|---|---|---|
| `%Y` | 4-digit year | 2024 |
| `%m` | month (01-12) | 03 |
| `%d` | day (01-31) | 15 |
| `%H` | hour (24h) | 14 |
| `%M` | minute | 30 |
| `%S` | second | 45 |
| `%A` | full weekday name | Friday |
| `%B` | full month name | March |

### Date arithmetic with `timedelta`
```python
from datetime import timedelta

tomorrow = today + timedelta(days=1)
last_week = today - timedelta(weeks=1)
diff = date(2024, 3, 15) - date(2024, 1, 1)   # a timedelta object
diff.days                                       # number of days between two dates
```

### Why this matters for Data Analysts
- Every "time series" or date-indexed dataset relies on these concepts underneath Pandas (`pd.Timestamp`, `pd.to_datetime()` are built directly on Python's `datetime`).
- Common interview/practical tasks: calculating someone's age from a birthdate, finding the number of days between two events, extracting the day-of-week/month/year from a timestamp column, formatting a date for a report or filename.
- `time.time()` (from the `time` module) gives you a raw Unix timestamp — useful for simple performance timing (`start = time.time(); ...; print(time.time() - start)`).


---

## 25. Python + Databases (SQL connectivity)

As a Data Analyst you'll very often need to pull data directly from a database rather than a flat file. The pattern below (Python's **DB-API 2.0** standard) is the same shape across virtually every database driver — learn it once, apply it everywhere.

### The standard workflow (identical structure for every database)
```python
import sqlite3   # or: import pymysql / import psycopg2 / etc. depending on the database

# 1. Connect
con = sqlite3.connect("mydata.db")     # for MySQL/Postgres you'd pass host/user/password/dbname instead

# 2. Create a cursor — the object used to run queries and hold results
cursor = con.cursor()

# 3. Execute a query
cursor.execute("SELECT * FROM employees WHERE salary > ?", (50000,))

# 4. Fetch results
rows = cursor.fetchall()       # all matching rows, as a list of tuples
row = cursor.fetchone()         # just the next row
some = cursor.fetchmany(5)      # next 5 rows

# 5. For INSERT/UPDATE/DELETE, commit the change
cursor.execute("INSERT INTO employees VALUES (?, ?, ?)", (101, "Durga", 55000))
con.commit()

# 6. Close resources (or use `with` where the driver supports it)
cursor.close()
con.close()
```

### Key methods to know (same across drivers)
| Method | Purpose |
|---|---|
| `connect()` | open a connection to the database |
| `cursor()` | create a cursor to run queries |
| `execute(sql, params)` | run a single query — **always use parameterized queries** (the `?`/`%s` placeholders), never string-format raw values into SQL |
| `executemany(sql, list_of_params)` | run the same query for many rows efficiently (bulk insert) |
| `fetchone()` / `fetchall()` / `fetchmany(n)` | retrieve results |
| `commit()` | save changes (required for INSERT/UPDATE/DELETE) |
| `rollback()` | undo uncommitted changes if something went wrong |
| `close()` | release the connection/cursor |

### SQL injection — a real security concept worth knowing
```python
# NEVER do this — vulnerable to SQL injection:
cursor.execute(f"SELECT * FROM users WHERE name = '{user_input}'")

# ALWAYS do this — parameterized/prepared query:
cursor.execute("SELECT * FROM users WHERE name = ?", (user_input,))
```
This is a very common interview question for any role touching databases — know why parameterized queries matter, not just how to write them.

### Common drivers you'll actually use as a Data Analyst
| Database | Library |
|---|---|
| SQLite (built-in, file-based, zero setup) | `sqlite3` (standard library — no install needed) |
| MySQL | `pymysql` or `mysql-connector-python` |
| PostgreSQL | `psycopg2` |
| SQL Server | `pyodbc` |
| Any of the above, via SQLAlchemy's unified interface | `sqlalchemy` |

> **[Updated]** The original notes focus specifically on `cx_Oracle` (Oracle database). Oracle shows up far less often in typical Data Analyst tooling today than PostgreSQL, MySQL, SQL Server, and cloud warehouses (Snowflake, BigQuery, Redshift) — the connection pattern above is identical for all of them (just swap the driver/connection string), so it's more useful to understand the *pattern* than to memorize any one driver's specifics.

### The pattern you'll actually use most in real analyst work
In practice, once connected, you'll usually hand the connection straight to Pandas rather than manually looping over `fetchall()`:
```python
import pandas as pd
df = pd.read_sql("SELECT * FROM sales WHERE year = 2024", con)
```
Still, understanding the raw `connect → cursor → execute → fetch → commit → close` pattern matters for interviews and for any write/insert/update operations, which `pd.read_sql` doesn't handle (use `df.to_sql()` for writing DataFrames back to a database, covered in your Pandas notes).


---

## 26. Copy Semantics: Mutable vs Immutable, Shallow vs Deep Copy [Added]

This consolidates a theme that shows up throughout the book (§3, §9, §11) into one place — it's one of the **most-tested conceptual areas** in Python interviews at every level, and a common source of real bugs.

### Mutable vs Immutable — recap
| Immutable (can't change in place) | Mutable (can change in place) |
|---|---|
| `int`, `float`, `bool`, `complex`, `str`, `tuple`, `frozenset`, `bytes` | `list`, `dict`, `set`, `bytearray` |

### Why it matters: function arguments
Python passes arguments by **object reference** — but whether the caller sees changes depends on the object's mutability:
```python
def modify(x):
    x.append(4)          # mutates the SAME list object -> caller sees the change

l = [1, 2, 3]
modify(l)
print(l)                 # [1, 2, 3, 4]

def reassign(x):
    x = x + [4]           # creates a NEW list, rebinds local name x -> caller unaffected

l = [1, 2, 3]
reassign(l)
print(l)                 # [1, 2, 3] — unchanged
```
> **Interview framing:** Python is often described as "pass by object reference" — neither pure pass-by-value nor pure pass-by-reference like C++. Mutating an object in place is visible to the caller; rebinding the local name to a new object is not.

### Aliasing vs Copying (recap from §9)
```python
a = [1, 2, 3]
b = a          # ALIAS — same object, two names
b.append(4)
print(a)       # [1, 2, 3, 4] -- a changed too!
```

### Shallow copy vs Deep copy — the trap with **nested** structures
A shallow copy duplicates the outer container but **still shares references to any nested mutable objects inside it**.
```python
import copy

original = [[1, 2], [3, 4]]

shallow = original.copy()           # or copy.copy(original), or original[:]
shallow[0].append(99)
print(original)                      # [[1, 2, 99], [3, 4]] -- inner list was SHARED, original changed too!

deep = copy.deepcopy(original)
deep[0].append(100)
print(original)                      # unaffected -- deepcopy recursively copies everything nested
```

| | Shallow copy | Deep copy |
|---|---|---|
| How | `.copy()`, `list[:]`, `dict.copy()`, `copy.copy()` | `copy.deepcopy()` |
| Nested mutable objects | shared with the original | fully, independently duplicated |
| Speed | faster | slower (more work) |
| Use when... | the container has only flat/immutable elements, or you *want* shared inner objects | the container has nested lists/dicts and you need a truly independent copy |

### Why this matters for real analyst work
This exact bug shows up constantly with lists of dicts, nested JSON, or reused default arguments:
```python
def add_item(item, bucket=[]):    # DANGEROUS: mutable default argument!
    bucket.append(item)
    return bucket

add_item("a")   # ['a']
add_item("b")   # ['a', 'b']  <-- surprise! the same list is reused across calls
```
> **Classic interview gotcha:** mutable default arguments (`def f(x=[])`) are created **once**, when the function is defined — not fresh on every call. The fix: use `None` as the default and create the mutable object inside the function.
```python
def add_item(item, bucket=None):
    if bucket is None:
        bucket = []
    bucket.append(item)
    return bucket
```


---

## 27. Environment & Package Management (job-relevant basics) [Added]

Not covered in the original notes at all, but this is genuinely necessary for real job work — every team you join will expect you to know this.

### `pip` — Python's package manager
```bash
pip install pandas
pip install pandas==2.2.0        # specific version
pip list                          # see installed packages
pip show pandas                    # details about a package
pip freeze > requirements.txt      # export exact installed versions
pip install -r requirements.txt    # install from a requirements file
```

### Virtual environments — why they matter
A virtual environment is an isolated Python installation for a specific project, so its package versions don't conflict with other projects (or the system Python).
```bash
python -m venv myenv          # create a virtual environment named "myenv"
myenv\Scripts\activate         # activate it (Windows)
source myenv/bin/activate      # activate it (Mac/Linux)
deactivate                     # exit the environment
```
> **Interview framing:** *"Why use a virtual environment?"* — Different projects often need different (sometimes conflicting) versions of the same library. A virtual environment keeps each project's dependencies isolated, and `requirements.txt` (or similar) makes the project reproducible on another machine.

### Jupyter Notebooks — the day-to-day analyst environment
Most real analyst work happens interactively in Jupyter (Notebook/Lab) or similar (VS Code notebooks, Google Colab, Databricks notebooks) rather than running `.py` scripts from the terminal. Know the basics: cells run independently and share state, `%timeit` and other "magic commands" exist for quick profiling, and `!pip install` runs a shell command directly from a cell.

### `conda` (Anaconda/Miniconda) — an alternative to pip + venv
Common in data science specifically because it also manages non-Python dependencies (e.g., compiled C libraries that NumPy/Pandas rely on).
```bash
conda create -n myenv python=3.11
conda activate myenv
conda install pandas numpy
```
You don't need to be a `conda` expert, but recognize it as the other major tool in this space — many data teams use Anaconda distributions by default.


---

## 28. Data Analyst Interview Question Bank [Added]

A quick-reference list of the questions that come up repeatedly for Python-for-Data-Analyst interviews, organized by topic, with pointers back to the relevant section.

### Core language
- What's the difference between a list and a tuple? When would you use each? (§9, §10)
- What's the difference between `is` and `==`? (§5)
- Explain mutable vs immutable types with examples. (§3, §26)
- What happens when you pass a list into a function and modify it inside? (§26)
- What's the difference between shallow copy and deep copy? (§26)
- Why shouldn't you use a mutable default argument? (§26)
- What's the difference between `append()` and `extend()`? Between `remove()` and `pop()`? (§9)
- Explain `*args` and `**kwargs`. (§15)
- What's a list comprehension? Rewrite this `for` loop as one. (§13)
- What's the difference between `range()` and a list? (§3)
- Explain how Python resolves variable scope (`global` vs `local`, `LEGB` rule). (§14)
- What are Python's four fundamental collection types and how do they differ? (§9–§12)

### Functions & functional concepts
- What's a lambda function, and when would you use one over `def`? (§16)
- What's the difference between `map()`/`filter()` and list comprehensions? (§16)
- Explain what a decorator is and write a simple one. (§18)
- What's the difference between a generator and a normal function? Why use `yield`? (§17)
- What's the difference between an iterable and an iterator? (§17)

### OOP
- Explain the difference between a class and an object. (§22)
- What's `self`, and why is it the first parameter? (§22)
- Explain the difference between instance, class (static), and local variables. (§22)
- Does Python support method overloading? Why or why not? (§22)
- Explain method overriding with an example, and what `super()` does. (§22)
- What's the difference between `@staticmethod` and `@classmethod`? (§22)
- What's duck typing? (§22)

### Exceptions & robustness
- What's the difference between a syntax error and an exception? (§21)
- Walk me through `try`/`except`/`else`/`finally` — when does each run? (§21)
- What's the difference between `KeyError` and `IndexError`? (§21)
- How would you handle a missing file gracefully? (§20, §21)

### Strings & data cleaning (very common for analyst-specific interviews)
- How would you check if a string is a palindrome? (§8)
- How would you count the occurrences of each character in a string, without using `Counter`? (§8, §12)
- How would you remove whitespace, then check if two strings are equal ignoring case? (§8)
- Given a messy column of phone numbers, how would you validate/extract the valid ones? (§23)
- How would you deduplicate a list while preserving order? (§8, §11)

### Files, JSON, and data I/O
- How do you read a large file without loading it entirely into memory? (§17, §20)
- What's the difference between `json.load()` and `json.loads()`? (§20)
- Why use `with open(...)` instead of manually calling `open()`/`close()`? (§20)

### SQL / database
- Walk me through how you'd connect to a database from Python and pull results into a DataFrame. (§25)
- What's SQL injection, and how do parameterized queries prevent it? (§25)

### General / practical judgement (very common at the analyst level)
- How would you handle missing or duplicate data in a dataset? (conceptual — ties to your Pandas notes)
- Tell me about a time you had to clean messy real-world data. What tools did you use?
- Walk me through your general process for exploring a new dataset in Python.
- What's the difference between `.py` scripts and Jupyter notebooks, and when do you use each? (§27)

---

## 29. Common Coding Patterns Asked in Interviews [Added]

Short, focused practice patterns — the kind of thing you should be able to write from memory without looking anything up. (Replaces the original notes' 100-pattern star/number printing exercises, which are lower-value for Data Analyst interviews specifically.)

### String / array manipulation
```python
# Reverse a string
s[::-1]

# Check palindrome
s == s[::-1]

# Check anagram
sorted(s1) == sorted(s2)

# Count character frequency
from collections import Counter
Counter(s)

# Find duplicates in a list
[x for x in set(l) if l.count(x) > 1]

# Remove duplicates, preserve order
list(dict.fromkeys(l))     # a clean, modern idiom (dicts preserve insertion order, 3.7+)

# Find the most common element
Counter(l).most_common(1)
```

### Basic aggregation without Pandas (good for testing raw Python fluency)
```python
# Group values by a key (classic "group by" in plain Python)
from collections import defaultdict
groups = defaultdict(list)
for name, dept in records:
    groups[dept].append(name)

# Running total / cumulative sum
totals = []
running = 0
for x in values:
    running += x
    totals.append(running)
```

### Two-list comparison (very common "compare datasets" style question)
```python
set(list_a) - set(list_b)        # in a, not in b
set(list_a) & set(list_b)        # in both
set(list_a) ^ set(list_b)        # in exactly one
```

### FizzBuzz (still occasionally asked as a basic warm-up)
```python
for i in range(1, 101):
    if i % 15 == 0: print("FizzBuzz")
    elif i % 3 == 0: print("Fizz")
    elif i % 5 == 0: print("Buzz")
    else: print(i)
```

### Simple recursion (factorial, Fibonacci — know both the recursive and iterative versions)
```python
def factorial(n):
    return 1 if n == 0 else n * factorial(n - 1)

def fibonacci(n):
    a, b = 0, 1
    for _ in range(n):
        a, b = b, a + b
    return a
```

---

## 30. Essential Built-ins You'll Actually Use [Added]

These were under-covered in earlier sections but are used constantly in real code and asked about constantly in interviews.

### `zip()` — combine multiple iterables element-by-element
```python
names = ["Durga", "Ravi", "Sunny"]
scores = [90, 85, 78]

for name, score in zip(names, scores):
    print(name, score)

pairs = list(zip(names, scores))          # [('Durga', 90), ('Ravi', 85), ('Sunny', 78)]
d = dict(zip(names, scores))                # {'Durga': 90, 'Ravi': 85, 'Sunny': 78} — very common pattern
```
If the iterables are different lengths, `zip()` stops at the shortest one (no error). `zip(*pairs)` "unzips" back into separate tuples — a common trick for transposing rows/columns of plain-Python tabular data.

### `enumerate()` — get index + value while looping
```python
for i, name in enumerate(names):
    print(i, name)

for i, name in enumerate(names, start=1):   # start counting from 1 instead of 0
    print(i, name)
```
Prefer this over manually tracking a counter variable (`i = 0; ... i += 1`) — it's the idiomatic, expected way to do this in Python and interviewers notice when candidates don't use it.

### `sorted()` with a custom key — very high-frequency interview question
```python
sorted(numbers)                                  # ascending
sorted(numbers, reverse=True)                    # descending
sorted(words, key=len)                            # sort by a derived value
sorted(students, key=lambda s: s.marks)            # sort objects by an attribute
sorted(students, key=lambda s: s.marks, reverse=True)

# Sorting a dictionary by its VALUES — extremely common interview ask
d = {"a": 3, "b": 1, "c": 2}
sorted(d.items(), key=lambda item: item[1])        # [('b', 1), ('c', 2), ('a', 3)]

# Same thing, using operator.itemgetter (slightly faster, common alternative style)
from operator import itemgetter
sorted(d.items(), key=itemgetter(1))
```
> Remember: `sorted()` returns a **new** list and leaves the original unchanged; `.sort()` (list method, §9) sorts **in place** and returns `None`.

### `all()` and `any()` — quick validation checks over a collection
```python
all(x > 0 for x in numbers)     # True only if EVERY element satisfies the condition
any(x < 0 for x in numbers)      # True if AT LEAST ONE element satisfies the condition
```
Very handy for data-quality checks: `all(row["age"] >= 0 for row in records)` to validate no negative ages, etc.

### `collections` module — the practical extensions to the built-in types
```python
from collections import Counter, defaultdict, namedtuple

# Counter — frequency counting in one line (replaces the manual dict-counting loop from §12)
Counter("mississippi")                 # Counter({'i': 4, 's': 4, 'p': 2, 'm': 1})
Counter(word_list).most_common(3)       # top 3 most frequent items

# defaultdict — a dict with an automatic default value, avoids KeyError/manual get()
groups = defaultdict(list)
for name, dept in records:
    groups[dept].append(name)           # no need to check "if dept not in groups" first

# namedtuple — a lightweight, readable alternative to a plain tuple or a full class
Point = namedtuple("Point", ["x", "y"])
p = Point(10, 20)
p.x, p.y                                # access by name instead of index — more readable than p[0], p[1]
```
> **Interview framing — `namedtuple` vs `dict` vs class:** a `namedtuple` is immutable, memory-efficient, and gives attribute-style access (`p.x`) with positional/tuple behavior underneath — a good middle ground when you want a simple, fixed-structure record without writing a full class.

### `itertools` module — worth knowing exists [brief]
```python
from itertools import combinations, permutations, chain, groupby

list(combinations([1,2,3], 2))     # [(1,2), (1,3), (2,3)]
list(chain([1,2], [3,4]))           # [1, 2, 3, 4] — flatten/concatenate iterables
```
You won't need this constantly as an analyst, but recognizing `itertools.groupby` (used for grouping *pre-sorted* data) and `combinations`/`permutations` (used in sampling/statistics-adjacent questions) is a reasonable bar for 3 years of experience.

---

## 31. Writing Custom Iterators & Context Managers [Added]

These build directly on §17 (Iterators & Generators) and §20 (File Handling's `with` statement) — worth understanding *how* those tools work internally, since "write your own" versions are a fair ask at the 3-year mark.

### Building your own iterator (the mechanics behind `for`)
Any class that implements `__iter__()` (returns the iterator object, usually `self`) and `__next__()` (returns the next value, raises `StopIteration` when done) can be looped over with a `for` loop.
```python
class Countdown:
    def __init__(self, start):
        self.current = start

    def __iter__(self):
        return self

    def __next__(self):
        if self.current <= 0:
            raise StopIteration
        self.current -= 1
        return self.current + 1

for num in Countdown(5):
    print(num)     # 5 4 3 2 1
```
This is exactly what happens invisibly whenever you loop over a list, dict, or file — and it's why generators (§17, using `yield`) are usually the simpler alternative when you just need iteration behavior without a full class.

### Building your own context manager (the mechanics behind `with`)
A `with` block calls `__enter__()` on entry and `__exit__()` on exit — guaranteed, even if an exception occurs. This is how `open()` guarantees the file gets closed (§20).

**Class-based version:**
```python
class Timer:
    def __enter__(self):
        import time
        self.start = time.time()
        return self
    def __exit__(self, exc_type, exc_value, traceback):
        import time
        print(f"Elapsed: {time.time() - self.start:.2f}s")
        return False    # False = don't suppress exceptions; True would swallow them

with Timer():
    slow_data_load()
```

**Simpler, more common style — using `contextlib`:**
```python
from contextlib import contextmanager
import time

@contextmanager
def timer():
    start = time.time()
    yield
    print(f"Elapsed: {time.time() - start:.2f}s")

with timer():
    slow_data_load()
```
> **Why this matters for analysts:** you'll use `with` constantly (files, database connections in §25, sometimes Pandas' `pd.option_context()` for temporary display settings) — understanding the mechanism behind it, not just the syntax, is a legitimate "do you actually understand Python or just pattern-match syntax" interview signal.

---

## 32. A Few More Concepts Worth Knowing at 3 Years [Added]

Quick-hit additions — each is a plausible standalone interview question, but none needs a full section.

**`__str__` vs `__repr__`**
```python
class Point:
    def __init__(self, x, y):
        self.x, self.y = x, y
    def __str__(self):
        return f"({self.x}, {self.y})"        # readable, for end users — used by print()
    def __repr__(self):
        return f"Point(x={self.x}, y={self.y})"  # unambiguous, for developers — used by the REPL/debugger/logs
```
Rule of thumb: `__repr__` should ideally be something you could paste back into Python to recreate the object; `__str__` is for human-friendly display. If you only define one, define `__repr__` — Python falls back to it for `print()` if `__str__` is missing, but not the other way around.

**Type hints** — increasingly standard in real production code, though not enforced at runtime:
```python
def calculate_total(price: float, quantity: int) -> float:
    return price * quantity

from typing import List, Dict, Optional
def process(records: List[Dict[str, int]]) -> Optional[float]:
    ...
```
They don't change how the code runs — Python ignores them at runtime — but they help tooling (IDE autocomplete, `mypy` static checking) and make function contracts self-documenting. Worth using in any code you'd show in a portfolio or take-home assignment.

**The Global Interpreter Lock (GIL) — conceptual, not deep**
CPython (the standard Python implementation) has a lock that allows only one thread to execute Python bytecode at a time, even on a multi-core machine. This is *why* raw Python `for` loops don't get faster from threading for CPU-bound work, and *why* NumPy/Pandas operations (which drop down into compiled C code) are dramatically faster than an equivalent pure-Python loop — the C code runs outside the GIL's per-instruction overhead and is vectorized besides. You don't need deep GIL internals for a Data Analyst interview, but being able to say *"that's part of why we vectorize with Pandas/NumPy instead of writing Python for-loops over rows"* is a strong, relevant answer if performance comes up.

**Abstract Base Classes (`abc` module)** — occasionally asked in OOP design questions:
```python
from abc import ABC, abstractmethod

class Shape(ABC):
    @abstractmethod
    def area(self):
        pass

class Circle(Shape):
    def __init__(self, r): self.r = r
    def area(self): return 3.14159 * self.r ** 2

# Shape() -> TypeError: Can't instantiate abstract class
```
Forces subclasses to implement specific methods — Python's version of an "interface" or "contract." Lower priority than everything else in this document, but recognizable if it comes up.

**The walrus operator `:=` (Python 3.8+)** — lets you assign inside an expression:
```python
if (n := len(data)) > 100:
    print(f"Large dataset: {n} rows")
```
Mostly a readability/conciseness feature — not essential, but you may see it in modern codebases and should recognize what it does if asked.

---

## 33. Real Gotchas & Everyday Idioms [Added]

The last of the genuine gaps — these are things that either (a) trip people up in interviews specifically because they're counter-intuitive, or (b) are used so often in real code that not knowing them stands out.

### Late-binding closures — a classic, very commonly asked gotcha
```python
funcs = []
for i in range(3):
    funcs.append(lambda: i)

[f() for f in funcs]     # [2, 2, 2]  <-- NOT [0, 1, 2]!
```
Each lambda doesn't capture the *value* of `i` at creation time — it captures the *variable* `i` itself, and looks it up when finally called. By the time you call them, the loop has finished and `i` is `2` for all of them. **The fix** — force early binding with a default argument:
```python
funcs = [lambda i=i: i for i in range(3)]
[f() for f in funcs]     # [0, 1, 2]  -- correct
```
This exact pattern (and fix) is a favorite "do you actually understand Python scoping" interview question.

### Merging dictionaries — a very ordinary, frequently-used pattern
```python
d1 = {"a": 1, "b": 2}
d2 = {"b": 20, "c": 3}

merged = {**d1, **d2}     # {'a': 1, 'b': 20, 'c': 3}  -- d2's values win on key conflicts
merged = d1 | d2           # same result, Python 3.9+ syntax
d1.update(d2)               # merges d2 INTO d1 in place (mutates d1)
```

### Exception variable scope — a real Python-3-specific gotcha
```python
try:
    1 / 0
except Exception as e:
    print(e)                # fine, works here

print(e)                     # NameError: name 'e' is not defined
```
In Python 3, the exception variable (`e`) is automatically deleted once the `except` block ends — a deliberate change from Python 2, made to avoid reference cycles. If you need the error message afterward, assign it to a separate variable inside the block:
```python
except Exception as e:
    error_message = str(e)
print(error_message)          # works — this is a normal variable
```

### Re-raising exceptions
```python
try:
    risky_call()
except ValueError as e:
    logging.error("bad value")
    raise                       # re-raises the SAME exception, preserving the original traceback

# Exception chaining — makes clear a new error was caused by an earlier one:
try:
    parse(data)
except ValueError as e:
    raise RuntimeError("Pipeline failed at parse step") from e
```

### `reversed()` — the function form of `[::-1]`
```python
list(reversed([1, 2, 3]))     # [3, 2, 1]
for x in reversed(my_list):    # iterate backward without creating a reversed copy up front
    print(x)
```

### List slice assignment — an underused but real capability
```python
l = [1, 2, 3, 4, 5]
l[1:3] = [20, 30, 40]          # replaces indices 1-2 with THREE new values -- list grows
print(l)                        # [1, 20, 30, 40, 4, 5]
```
Rarely the star of an interview question, but occasionally shows up when discussing how lists differ from arrays in other languages (Python lists can grow/shrink via slice assignment, not just `append`/`insert`).

---

*End of notes. This document intentionally excludes NumPy, Pandas, Matplotlib, and Seaborn — refer to your separate library-specific notes for those. If you'd like, this same structure/approach can be extended into a companion "SQL for Data Analysts" reference or a dedicated Pandas interview-prep document.*
