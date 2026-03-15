# Lab 04 Restructure — Design Spec

**Date:** 2026-03-16
**File:** `labs/Lab04.qmd`
**Goal:** Restructure Lab 04 (Central Limit Theorem) so that after a 15-min reflection, students complete Exercises 1–4 within 75 minutes. Exercises 5–6 become take-home.

## Context

- Students are first-year undergrads (environmental science, agriculture, vet science) with ~3 weeks of R experience.
- Lecture 04 covers: probability distributions → normal distribution (pnorm/qnorm/dnorm) → standardisation/z-scores → sampling distributions → CLT → standard error.
- Height data will be pre-collected during the lecture and provided as a CSV download in `labs/data/`.

## Constraints

- 90 min total session: 15 min reflection + 75 min exercises.
- Target ~62 min of exercise content, leaving ~13 min buffer for first-year friction.
- No new package dependencies (ABACUS rejected due to Normal-only limitation and maintenance risk).
- Existing solution blocks (`content-visible when-profile="solution"`) must be preserved/updated.

## Revised Exercise Structure

### Exercise 1 — How tall is ENVX1002? (~25 min)

**Learning goal:** Explore normal distributions with real data; visually experience the CLT via simulation.

**Flow:**

1. **Import pre-collected height data** from `data/heights.csv` (columns: `height`, `sex`). No manual data entry. (~2 min)

2. **Summary stats + histograms** for both genders. Male example scaffolded; students replicate for female. (~8 min)

3. **Discuss normality** — "Why is the normal distribution a good model for height data? Is it good for all data?" (~2 min)

4. **ABS comparison** — Values embedded directly in the lab text:
   - Males: mean 178.4 cm, SD 6.6 cm
   - Females: mean 163.9 cm, SD 6.6 cm
   - Note that reported heights were consistently higher than measured (~1.6 cm for males, ~1.0 cm for females)
   - Students compare their class data to these population values. (~3 min)

5. **Base-R CLT simulation** — Fully provided code block (students run it, not write it). Uses ggplot for consistency with the rest of the lab. Demonstrates CLT with two contrasting populations side-by-side:

   ```r
   set.seed(123)
   # Simulate sampling distributions for two populations
   # Population 1: Normal (like our height data)
   # Population 2: Skewed (exponential, like rainfall)
   normal_means <- replicate(1000, mean(rnorm(30, mean = 170, sd = 10)))
   skewed_means <- replicate(1000, mean(rexp(30, rate = 0.1)))

   # Combine for plotting
   sim_data <- data.frame(
     sample_mean = c(normal_means, skewed_means),
     population = rep(c("Normal population", "Skewed population"), each = 1000)
   )

   ggplot(sim_data, aes(x = sample_mean)) +
     geom_histogram(bins = 30, fill = "steelblue", colour = "white") +
     facet_wrap(~population, scales = "free") +
     labs(x = "Sample Mean", y = "Frequency",
          title = "Sampling distributions of the mean (n = 30)")
   ```

   Students observe that both produce approximately normal sampling distributions at n=30. Demonstrator guides discussion: "What changes as sample size increases? What does this tell us about the shape of the original population?" (~5 min)

6. **Coding confirmation** — Two-step scaffold. All code is student-facing (not hidden). The probability question is: "What proportion of sample means are greater than 180?" which mirrors the simulation-vs-exact comparison from the original lab.

   ```r
   # Step 1: Generate ONE sample of 30 heights and calculate the mean
   one_sample <- rnorm(30, mean = m_mean, sd = m_sd)
   mean(one_sample)

   # Step 2: Now do it 1000 times using replicate()
   sample_means <- replicate(1000, mean(rnorm(30, mean = m_mean, sd = m_sd)))

   # Plot the distribution of sample means
   ggplot(data.frame(sample_mean = sample_means), aes(x = sample_mean)) +
     geom_histogram(bins = 30, fill = "lightblue", colour = "white") +
     labs(x = "Sample Mean Height (cm)", y = "Frequency",
          title = "Distribution of 1000 sample means (n = 30)")
   ```

   Then a comparison line (provided, students run it):

   ```r
   # Compare: what proportion of sample means exceed 180?
   sum(sample_means > 180) / 1000  # simulated
   pnorm(180, mean = m_mean, sd = m_sd / sqrt(30), lower.tail = FALSE)  # exact
   ```

   Solution block: not needed here — all code is shown. The solution block for this section covers only the female summary stats/histogram from step 2. (~5 min)

**What's removed from current lab:**
- Manual data collection via Google Sheets
- The entire `# Simulating height distribution` section (current lines 142-238), including the heading — its pedagogical content is replaced by steps 5-6 above
- The full simulation block (n=10, 100, 1000, 10000 with tables and probability comparisons)
- PDF navigation to find ABS values

**What's new:**
- Pre-collected CSV data import
- Base-R CLT simulation with normal + skewed populations
- Two-step `replicate()` scaffold
- Simulated vs exact probability comparison

### Exercise 2 — Milkfat (~25 min)

**Learning goal:** Apply normal distribution probability calculations; transition from individual to sampling distributions.

**Flow:**

1. **Import data** — `read_excel("data/ENVX1002_Data4.xlsx", sheet = "Milkfat")`. (~2 min)

2. **Summary stats** — mean, median, SD. Scaffolded with `mean()` example. (~3 min)

3. **Context note** — Provided fact: "Based on the mean milkfat of ~4.2%, these are likely Jersey cows — a breed known for high milkfat content compared to the more common Holstein-Friesian (~3.5%)." No external link investigation. (~1 min)

4. **Histogram + boxplot** — Create both, discuss normality. (~4 min)

5. **Probability calculations** — Part 1 / Part 2 sub-headings from the current lab are collapsed into a single flowing exercise. Student-facing sub-parts use roman numerals matching the current lab where possible:
   - (iv) Percentage of cows with ≥5.5% fat (breakfast milk) — empirical count using `sort()`
   - (v) Percentage with ≥3.2% fat (full cream milk) — "your turn"
   - Transition paragraph: "Let X represent the milkfat content for the population of this breed of cows. Assuming the population is normal, use the sample mean and standard deviation as estimates of the population parameters."
   - Draw normal curve with `stat_function()` (scaffolded code from current lab)
   - (vi) P(X < 4) using `pnorm()` with shaded area plot (scaffolded)
   - (vii) P(X > 4.5) using `pnorm()` — "your turn" adapting the plot (~8 min)

6. **`qnorm` question (new)** — "What milkfat percentage is exceeded by 95% of cows?" Introduces inverse normal in a guided context. (~2 min)

   Solution block content:

   ```r
   # 95% of cows exceed this value, so we want the 5th percentile
   qnorm(0.05, mean = 4.16, sd = 0.30)
   ```

   Brief prose: "We use `qnorm(0.05, ...)` because if 95% of cows exceed a value, then 5% are below it — we're looking for the 5th percentile." No visualisation required for this sub-part.

7. **Sampling distribution** — Key conceptual leap:
   - "For a sample of 10 cows, what is P(X̄ > 4.2)?"
   - Identify distribution of X̄: mean = μ, SD = σ/√n
   - Calculate SE = 0.30/√10
   - Use `pnorm()` with SE
   - Visualise sampling distribution vs population distribution (~5 min)

**What's removed from current lab:**
- "What type of cows could they be?" (Lactalis link investigation)
- "What state could they be from?" (Dairy Australia PDF investigation)

**What's new:**
- Jersey cow context provided as a brief note
- `qnorm` question added

### Exercise 3 — Skin cancer SE (~5 min)

**No changes.** 9 rats, mean remission 400 hours, SD 30 hours — calculate SE. Scaffolded with solution block.

### Exercise 4 — Soil carbon SE (~7 min)

**No changes.** 12 observations, mean 1.2%, SD 0.4% — find n for SE of 0.1%. Rearrange SE formula. Solution block preserved.

### Take-home exercises

Exercises 5 and 6 are grouped under a top-level `#` heading: `# Take-home exercises`. An introductory sentence:

> "The following exercises are for you to complete in your own time. They provide additional practice with the concepts covered in this lab."

Exercise numbering is preserved as 5 and 6 (not renumbered).

### Exercise 5 — Media article (MOVED TO TAKE-HOME)

**Moved from in-lab to take-home.** Content unchanged. Read SMH article, find sentences about populations vs samples, SE formula, sample size effects.

### Exercise 6 — Netball heights (TAKE-HOME, unchanged)

**No changes.** Tail/interval probabilities, `qnorm`. Stays as extra practice.

## Timing Summary

| Section | Est. time |
|---|---|
| Reflection activity | 15 min |
| Exercise 1 — Heights + CLT simulation | ~25 min |
| Exercise 2 — Milkfat + qnorm | ~25 min |
| Exercise 3 — Skin cancer SE | ~5 min |
| Exercise 4 — Soil carbon SE | ~7 min |
| **In-lab total** | **~62 min** |
| **Buffer** | **~13 min** |
| Exercise 5 — Media article (take-home) | — |
| Exercise 6 — Netball heights (take-home) | — |

## Data Requirements

- **New file needed:** `labs/data/heights.csv` with columns `height` (numeric, cm) and `sex` (character, "M" or "F"). To be populated from lecture-collected data before Tuesday's prac.
- **Existing file unchanged:** `labs/data/ENVX1002_Data4.xlsx` (Milkfat sheet)

## Setup Chunk Changes

```r
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, readxl)
```

No new packages required (ABACUS rejected).

## Solution Blocks

All existing solution blocks must be updated to match the restructured exercises. New solution blocks needed for:
- The `qnorm` question in Exercise 2
- The female summary stats/histogram in Exercise 1 (existing solution block, updated for CSV import)

Note: The `replicate()` and CLT simulation code in Exercise 1 steps 5-6 is fully provided (not hidden) — no solution block needed for those.

## Out of Scope

- No changes to Exercise 6 content
- No changes to the reflection section
- No changes to other lab files
- Height data file creation (will be done separately by the instructor)
