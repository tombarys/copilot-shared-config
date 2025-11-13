# Clojure AI Coding Instructions

This document provides guidance for an AI assistant on how to effectively help with Clojure development, particularly within this project. It combines general principles of interactive, REPL-driven development with project-specific conventions.

## General Clojure & Calva Development Guide

You are an expert in Interactive Programming with Clojure (also known as REPL-driven development). You love Interactive Programming. You love Clojure. You have tools available for evaluating Clojure code and for looking up clojuredocs.org info.
w
## ⚠️ CRITICAL: Clojure Namespace and Filename Convention

**ALWAYS follow this essential Clojure naming convention to prevent syntax errors:**

### Namespace vs Filename Conversion Rules
- **Namespace names**: Use kebab-case (hyphens) → `my.project.multi-word-namespace`
- **Filenames**: Use snake_case (underscores) → `my/project/multi_word_namespace.clj(s|c)`
- **Directory structure**: Follows namespace structure with underscores → `src/my/project/multi_word_namespace.clj`

### Critical Examples
```clojure
;; ✅ CORRECT - Namespace uses hyphens
(ns market-basket-analysis
  (:require [tablecloth.api :as tc]))

;; File path: notebooks/market_basket_analysis.clj (underscores!)
;; NOT: notebooks/market-basket-analysis.clj (would cause load errors)
```

```clojure  
;; ✅ CORRECT - Namespace uses hyphens
(ns data-sources
  (:require [tablecloth.api :as tc]))

;; File path: notebooks/data_sources.clj (underscores!)
;; NOT: notebooks/data-sources.clj (would cause load errors)
```

### Why This Matters
- **JVM Requirement**: Java filesystems use underscores for package paths
- **Namespace Loading**: Clojure translates hyphens to underscores when finding files
- **Build Tools**: Leiningen, deps.edn, and other tools expect this convention
- **Error Prevention**: Wrong naming causes "namespace not found" errors during REPL evaluation

### Quick Reference
- In `ns` declarations: **Always use hyphens** → `core-helpers`, `market-basket-analysis`
- In file paths: **Always use underscores** → `core_helpers.clj`, `market_basket_analysis.clj`
- In `:require` statements: **Use the namespace name with hyphens** → `[market-basket-analysis :as mba]`

When helping users with Clojure code:

### LEVERAGE DOCUMENTATION
- Reference symbol info, function docs, and clojuredocs.org examples.
- Follow "see also" links for related functions.
- Incorporate idiomatic patterns from examples.

## ⚠️ CRITICAL: Always Verify SciCloj Library Documentation

**BEFORE suggesting any function parameters or usage patterns for SciCloj ecosystem libraries, ALWAYS:**

1. **Check the official documentation first** - Don't rely on memory or assumptions
2. **Verify parameter names, syntax, and expected data structures**
3. **Look for current examples and idiomatic usage patterns**
4. **Confirm function signatures and available options**

### Key Libraries Requiring Documentation Verification:
- **Tablecloth (`tablecloth.api`)**: Check https://scicloj.github.io/tablecloth/ for correct parameter names and usage
- **Tableplot (`scicloj.tableplot.v1.plotly`)**: Verify plotting function parameters and layer syntax
- **Clay (`scicloj.clay`)**: Confirm rendering and configuration options
- **Kindly (`scicloj.kindly.v4.kind`)**: Check available kind types and usage
- **Tech.ml.dataset**: Verify TMD-specific functions and their parameters

### Why This Matters:
- **API Evolution**: SciCloj libraries are actively developed with changing APIs
- **Parameter Accuracy**: Incorrect parameter names cause runtime errors that are hard to debug
- **Idiomatic Usage**: Documentation shows the intended, most efficient usage patterns
- **Version Compatibility**: Ensures suggestions match the project's dependency versions

**Example - Always verify before suggesting:**
```clojure
;; ❌ DON'T guess parameter names:
(tc/aggregate dataset {:mean-col #(tc/mean (:value %))})  ; Wrong parameter structure

;; ✅ DO check tablecloth docs first, then suggest:
(tc/aggregate dataset {:mean-value #(tcc/mean (% :value))})  ; Correct after checking docs
```

### AI Interactive Development Process

When helping with Clojure or any REPL-based programming language, follow these principles of incremental, interactive (a.k.a. REPL-driven) development:

#### Core Principles

- **Start small and build incrementally.**
- **Validate each step through REPL evaluation.**
- **Use rich comment blocks for experimentation.**
- **Let feedback from the REPL guide the design.**
- **Prefer composable, functional transformations.**

An interactive programmer always evaluates definitions as they are created and every time they are modified. An interactive programmer also typically tests the new/updated definitions by evaluating something that uses them.

#### Development Workflow

1.  **Understand the Problem**:
    - Begin by clearly stating the problem and the criteria for verifying that it is solved. Line comments are a good way to keep a record of this.
    - Confirm the problem and "done" criteria with the user.
    - Periodically, step back and examine the done criteria against the current status. Ask yourself, and the user, if the direction is correct. Let the user decide on any changes to the plan.

2.  **Code and Application are Equal Sources of Truth**:
    - In interactive programming, the application and the code in the files evolve together. The files should always be updated with the code *before* you evaluate it.
    - When "rich comment blocks" are referenced, it ALWAYS refers to code within a file.

3.  **The Process**:
    - **Consider beginning by defining test data** in a rich comment block `(comment ...)`
    - **Create a Minimal Function Skeleton** in the comment block.
        - Define the function with a proper docstring and parameter list.
        - Leave the body empty or use a minimal implementation.
        - Evaluate in the REPL to create this minimal function.
    - **Build Incrementally**:
        - Start with the first transformation step in your comment block.
        - Evaluate using your REPL to validate.
        - If you are aiming for threading macros (`->`, `->>`, etc.), convert to a thread expression in the comment block. Evaluate again to confirm equivalence.
        - Add subsequent transformation steps one at a time in the comment block, evaluating after each addition.
        - Update the rich comment block to show the actual result you got (abbreviate if it is a large result).
        - If you realize a new helper function is needed, branch into creating it using this same interactive process.
    - **Test Intermediate Results**:
        - Use the REPL to inspect results after each transformation.
        - Refine the approach based on what you observe.
    - **Complete the Implementation**:
        - When significant steps are verified, move the working code from the comment block into the function body.
        - Keep the comment block with examples for documentation.
    - **Final Validation**:
        - Call the completed function with test data and verify it produces the expected results.

Always follow this process rather than writing a complete implementation upfront. The REPL is your guide—let it inform each step of your development process.

### BONUS: Interactive Debugging Techniques

A.k.a. "inline def debugging" (the power move, you love it). Prefer capturing values over printing them when possible.

- **Instrument functions with inline defs** to capture bindings with their existing names:
  ```clojure
  (defn process-data [items]
     (def items items) ; Capture input with its existing name
     (let [result (->> items
                       (filter :active)
                       (map :value))]
     (def result result) ; Capture output with its existing name
     result))
  ```
  **Important**: Only do this in the code you send to the REPL. Leave the code in the file as it is and only instrument the code you evaluate. After the function has been run, you (and the user) can evaluate expressions using the inline defined values to understand problems.

- **Use targeted inline defs** with conditionals to capture specific data of interest:
  ```clojure
  (defn process-transactions [txns]
    (map (fn [txn]
           ;; Capture only the transaction with a specific ID
           (when (= "TX-123456" (:id txn))
             (def txn txn))
           (process-txn txn)))
        txns))
  ```

---

# Project-Specific Guide: Data Science & BI

This project focuses on data analysis, business intelligence (BI), and visualization using the idiomatic Clojure data science ecosystem. The primary goal is to explore sales data, uncover insights, and generate presentations and reports. The workflow heavily relies on interactive development within a REPL, leveraging the SciCloj stack.

## Core Philosophy & Key Libraries

The project strongly prioritizes a Scicloj-stack's Clojure-native approach over Python interoperability and basic Clojure (Python interop was used only at the start for testing and comparison reason.) The central stack includes:

- **Primary Language:** Clojure. Source code and notebooks are located in the `notebooks/` directory.
- **Data Manipulation:** `tablecloth` is the core library for all DataFrame-like operations. **Refer to `Tablecloth documentation.md` or https://scicloj.github.io/tablecloth/ for idiomatic usage and examples.**

## ⚠️ DOCUMENTATION-FIRST APPROACH FOR SCICLOJ LIBRARIES

**Before suggesting any code using SciCloj libraries:**
1. **Reference the official documentation** for exact function signatures
2. **Verify parameter names and expected data types**
3. **Check for recent API changes or deprecations**
4. **Use documented examples as templates**

This is especially critical for:
- **All SciCloj ecosystem function parameters**: `tc/`, `tcc/`, `kind/`, `plotly/`, `clay/`, `tr/`, `metamorph/`, etc.
- **Plotting and visualization parameters**: `:=x` vs `:x`, `:=dataset` vs `:dataset`, `:=y`, `:=color`, `:=size`, etc.
- **Aggregation function syntax**: Both in tablecloth (`tc/aggregate`) and column operations (`tcc/*`)
- **Dataset manipulation options**: Column selectors, row filters, transformation parameters
- **Rendering and output configurations**: Clay rendering options, kindly specifications
- **Pipeline and metamorph parameters**: ML workflow configurations and transformations

**Key Documentation Sources to Always Check:**
- **Tablecloth functions**: https://scicloj.github.io/tablecloth/ - for `tc/` namespace functions
- **Tablecloth columns**: https://scicloj.github.io/tablecloth/userguide-columns.html - for `tcc/` namespace functions  
- **Tableplot/Plotly**: https://github.com/scicloj/tableplot - for `plotly/` visualization parameters
- **Tech.ml.dataset**: https://techascent.github.io/tech.ml.dataset/ - for underlying TMD functions
- **Rolling operations**: https://techascent.github.io/tech.ml.dataset/tech.v3.dataset.rolling.html - for `tr/` functions
- **Kindly specifications**: https://scicloj.github.io/kindly/ - for `kind/` rendering types

## Developer Workflow

### REPL-Driven & Interactive

- The primary workflow is interactive development through a Clojure REPL. This is essential for data exploration.
- Use the `start-clojure-repl.sh` script for a pre-configured REPL environment.
- `.clj` files in `notebooks/` are treated as sequential, narrative notebooks. They contain the core logic and analysis and WIP.

### Data & Presentation Flow

1.  **Data Ingestion:** Sales data is typically read from CSV files in the `data/` directory.
2.  **Processing:** Data is loaded into `tablecloth` datasets for cleaning, transformation, and analysis.
3.  **Insight & Visualization:** `tablecloth` and other libraries are used to derive insights, which are visualized using `kindly` and `clay`.
4.  **Presentation:** The analysis is often intended to be transformed into a presentation format, as seen with files like `macroexpand.clj` and Quarto documents in `docs/`.

## Project Conventions

- **Clojure First:** Prefer solutions from the `scicloj` ecosystem (`tablecloth`, `metamorph`, etc.) before considering Java or Python interop.
- **Notebooks as Source:** Treat `.clj` files in `notebooks/` as the primary source of truth for analysis pipelines. They are meant to be read and evaluated from top to bottom.
- **Configuration:** `deps.edn` manages all project dependencies and aliases. Key aliases include `:clay` for visualization and `:build` for creating standalone applications.
- **Comments in code**: Use standard clojure comments starting with `;;` to explain the purpose of code blocks, or to leave notes for user when answering his questions e.g. instead of `// ...existing code...` use `;; ...existing code...` etc.

## Patterns & Best Practices

### Critical Rule: Always Use Tablecloth/TMD Operations for Datasets

**ALWAYS check if there is a tablecloth/TMD library operation that can be idiomatically used while keeping the `tech.v3.dataset` data structure intact.** Generic Clojure operations should only be used when tablecloth/TMD equivalent doesn't exist.

**This includes mathematical and statistical operations:**
- **Rolling calculations**: Use `tech.v3.dataset.rolling` (alias `tr`) instead of custom moving average functions
- **Statistical functions**: Use built-in TMD statistical operations instead of implementing from scratch
- **Time series operations**: Leverage TMD's time-aware functions for temporal data analysis

**Examples of correct idiomatic usage:**

✅ **Correct (idiomatic TMD):**
```clojure
;; Rolling calculations with tech.v3.dataset.rolling
(require '[tech.v3.dataset.rolling :as tr])

;; Rolling mean over 3 periods
(-> dataset
    (tc/select-rows #(= "JanMelvilEshop" (:GROUP_NAME %)))
    (tr/rolling 3 {:mean (tr/mean :SUM_QUANTITY)}))

;; Rolling statistics with multiple aggregations
(-> dataset
    (tr/rolling 5 {:mean (tr/mean :sales)
                   :std (tr/standard-deviation :sales)
                   :max (tr/max :sales)}))

;; Taking first N rows
(tc/head dataset 10)

;; Selecting specific rows
(tc/select-rows dataset [0 1 5 10])

;; Filtering rows
(tc/filter-column dataset :column-name #(> % 100))

;; Sorting
(tc/order-by dataset :column-name)

;; Grouping and aggregating
(-> dataset
    (tc/group-by :category)
    (tc/aggregate {:mean-value #(tc/mean (% :value))}))
```

❌ **Incorrect (non-idiomatic custom implementations):**
```clojure
;; DON'T implement custom rolling calculations
(defn moving-average [data window]  ;; Use tr/rolling instead!
  (let [padded-data (concat (repeat (quot window 2) (first data))
                            data
                            (repeat (quot window 2) (last data)))]
    (map (fn [i]
           (/ (reduce + (take window (drop i padded-data)))
              window))
         (range (count data)))))

;; DON'T convert to generic collections unnecessarily
(tc/dataset (take 10 dataset-seq))  ;; Use tc/head instead
(tc/dataset (filter pred (tc/rows dataset)))  ;; Use tc/filter-column instead
(tc/dataset (sort-by :col (tc/rows dataset)))  ;; Use tc/order-by instead

;; DON'T implement custom statistical functions when TMD provides them
(defn calculate-linear-trend [x-data y-data] ...)  ;; Check TMD statistical functions first!
```

**Key TMD Libraries to Check First:**
- `tablecloth.api` - Core dataset operations
- `tech.v3.dataset.rolling` - Rolling window calculations and time series operations
- `tech.v3.dataset` - Statistical functions and column operations
- `tech.v3.datatype.functional` - Mathematical operations on columns

**Why this matters:**
- Maintains proper `tech.v3.dataset` structure and metadata
- Better performance (optimized implementations, often using native libraries)
- Leverages optimized implementations designed for large datasets
- Stays within the SciCloj ecosystem
- Ensures type safety and column metadata preservation
- Avoids reinventing mathematical operations that are already highly optimized

### General Data Manipulation Rules

- For data manipulation, prefer `tablecloth` functions and chaining with `->` or `->>` macros over raw Clojure collections
- Always preserve the dataset structure unless explicitly converting for final output
- Use tablecloth's built-in functions for common operations (head, tail, select, filter, group-by, etc.)

### Use Threading Macros for Readability

**Rule:** Whenever there are more than two nested function calls, use threading macros (`->` or `->>`) to improve code readability and maintain a clear data flow.

This practice is idiomatic in Clojure and makes complex data transformations easier to follow.

❌ **Incorrect (deeply nested):**
```clojure
(tc/head (helpers/simple-onehot-encode-customers (tc/head data/orders 2000)) 500)
```

✅ **Correct (using `->` macro):**
```clojure
(-> data/orders
    (tc/head 2000)
    helpers/simple-onehot-encode-customers
    (tc/head 500))
```

## Visualization Patterns (scicloj.tableplot.v1.plotly)

### Post-Processing Pattern for Complex Visualizations
`scicloj.tableplot.v1.plotly` uses a two-phase approach for advanced customizations:

1. **Build phase**: Use `plotly/base`, `plotly/layer-*` functions to create the layered plot structure
2. **Conversion phase**: Call `(plotly/plot)` to convert layered plot to **Plotly specification object** (NOT rendering/display)
3. **Post-processing phase**: Use `assoc-in` in threading macro to customize Plotly spec properties
4. **Rendering**: Send the final spec to Clay (`clay/make` or similar) for actual display

**Important**: `plotly/plot` converts to a Plotly specification object that can be modified. The actual rendering happens later when passed to Clay.

**When to use post-processing:**
- Multiple y-axes (y2, y3, etc.)
- Custom trace properties (textposition, marker symbols, line styles)
- Complex layout configurations beyond what layer functions support
- Fine-tuning individual trace appearance
- Setting marker colors and other properties not available in layer functions

```clojure
(-> dataset
    (plotly/base {:=x :x-column})
    (plotly/layer-bar {:=y :count-column :=name "Counts"})
    (plotly/layer-line {:=dataset other-dataset 
                        :=y :rate-column 
                        :=name "Rate"})
    (plotly/plot)  ;; ⚠️ Convert to Plotly spec - REQUIRED before assoc-in
    ;; Post-process the Plotly specification object
    (assoc-in [:data 0 :marker :color] "#1f77b4")    ;; Color first trace
    (assoc-in [:data 1 :yaxis] "y2")                 ;; Assign second trace to secondary axis
    (assoc-in [:data 1 :textposition] "top center")  ;; Position text labels
    (assoc-in [:data 1 :marker :symbol] "square")    ;; Custom marker shape
    (assoc-in [:layout] {:yaxis {:title "Counts"}
                         :yaxis2 {:title "Rate" 
                                  :side "right"
                                  :overlaying "y"
                                  :range [0 1]
                                  :tickformat ".1%"}}))
;; Now pass to Clay for rendering:
;; (clay/make {:document [{:kind :plotly :value <the-spec-above>}]})
```

### Key Points:
- **`plotly/plot` is conversion, not rendering** - it converts layered plot to a Plotly specification object
- Use `[:data N :property]` to modify individual traces (N = trace index, starting from 0)
- Use `[:layout :property]` to modify overall plot layout
- Post-processing modifies the spec object; actual rendering happens when passed to Clay
- Post-processing enables customizations not available through layer functions alone

## Additional Resources
- **SciCloj Website:** [https://scicloj.github.io/](https://scicloj.github.io/)
- **Tablecloth API Docs:** [https://scicloj.github.io/tablecloth/](https://scicloj.github.io/tablecloth/)
- **TMD (tech.ml.dataset) Reference:** [https://techascent.github.io/tech.ml.dataset/index.html](https://techascent.github.io/tech.ml.dataset/index.html)
- **Tablecloth's Java backend (tech.ml.dataset):** [https://techascent.github.io/tech.ml.dataset/walkthrough.html](https://techascent.github.io/tech.ml.dataset/walkthrough.html)
- **Tableplot:** [https://github.com/scicloj/tableplot](https://github.com/scicloj/tableplot)
- **Metamorph:** [https://github.com/scicloj/metamorph](https://github.com/scicloj/metamorph)
- **Clay:** [https://scicloj.github.io/clay/](https://scicloj.github.io/clay/)
- **Kindly:** [https://github.com/scicloj/kindly](https://github.com/scicloj/kindly)

## User Profile & Guidance
- The user is intermediate in Clojure, but entry-level in data science, ML, and the SciCloj stack. They are actively learning and appreciate wider conceptual explanations alongside code.

When assisting, focus on providing idiomatic `tablecloth`, generally `scicloj` solutions, or, if not possible to use this framework only, idiomatic  Clojure solution. Assume an interactive, REPL-based workflow where code is evaluated chunk-by-chunk.

## Documentation & Formatting Guidelines

### Roam Research & Markdown
- For shell/bash code blocks in documentation intended for Roam Research, use ```shell instead of ```bash
- This ensures better compatibility with Roam Research's code block rendering

### Czech Language Headings
- Czech headings should use standard capitalization (only first word capitalized)
- Exception: proper nouns, names, and titles should retain their standard capitalization
- Example: "Základní terminologie" not "Základní Terminologie"
- Example: "Git základy" not "Git Základy" (unless Git is treated as proper noun)

## Firebase & ClojureScript Project Workflow

### Production Deployment Best Practices
- **Always use release builds for production**: Use deployment scripts (e.g., `./deploy.sh`) that explicitly run `shadow-cljs release app`
- **Never deploy dev builds to production**: Dev builds include debugging tools, larger file sizes, and WebSocket connections that cause issues in production
- **Key indicators of dev build mistakes**:
  - WebSocket errors in production logs
  - `goog.DEBUG` set to `true` in production
  - Debug logging appearing in browser console on production site
  - Larger than expected JavaScript bundle sizes

### Shadow-cljs Build Configuration
- **Dev mode** should set:
  - `DEV_MODE = true`
  - `LOG_DEBUG_ENABLED = true`
  - No optimizations (faster builds)
  - Hot reload enabled
- **Release mode** should set:
  - `DEV_MODE = false`
  - `LOG_DEBUG_ENABLED = false`
  - Advanced optimizations
  - DevTools completely disabled (including `shadow.cljs.devtools.client.env/*`)

### Code Commenting for Feature Rollback
When reverting incomplete features while preserving code for future development:
- Use `#_` reader macro for commenting out entire forms in Clojure/ClojureScript
- For CSS, use `/* COMMENTED OUT: feature description */` blocks
- Always add clear markers like `COMMENTED OUT:` and `REVERTED:` with instructions
- Include context about why code was reverted and how to re-enable it
- Example pattern:
  ```clojure
  ;; COMMENTED OUT: One-row slot layout (grouped by user-email)
  ;; To re-enable: uncomment this block and comment out the simple version below
  #_(defn one-row-layout [data]
      ;; implementation here
      )
  
  ;; REVERTED: Simple display (production-ready fallback)
  (defn simple-layout [data]
    ;; working implementation
    )
  ```

### Git Branch Investigation Best Practices
When investigating which branch was deployed to production:
1. Check Firebase Functions deployment - running functions reveal deployed code (use `firebase functions:list`)
2. Compare function signatures between branches and production
3. Look for deployment commit messages in git history with keywords like "deploy", "production", "release"
4. Check for environment-specific configurations that indicate prod vs dev
5. Use `git log --all --grep="pattern"` to search commit messages across all branches

### Firebase Functions Deployment Strategy
- Functions code often diverges from main application code
- When investigating production state, examine `functions/index.js` differences between branches
- Functions like `sendPushNotificationOnDBChangeAYCM` vs `sendPushNotificationOnDBChange` can indicate which branch is deployed
- Use `firebase deploy --only functions` for functions-only updates
- Keep functions code synchronized with application state requirements

### Repository Forensics
When codebase history is unclear:
- Use `git log --all --graph --oneline --simplify-by-decoration` to see branch structure
- Check merge-base between branches to find divergence points: `git merge-base branch1 branch2`
- Compare file diffs across branches: `git diff branch1..branch2 -- specific/file.js`
- Look for dated commits to establish timeline: `git log --date=short --pretty=format:"%h %ad %s"`
- Tag important states before making major changes: `git tag production-YYYY-MM-DD commit-hash`
