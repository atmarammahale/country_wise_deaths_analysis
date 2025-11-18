# COVID-19 Country-wise Data Analysis
# Dataset: country_wise_latest.csv (already imported as country_wise_latest)

# Set options for better display
options(scipen = 999)  # Disable scientific notation
par(mar = c(5, 5, 4, 2))  # Set margins for plots

# ==============================================================================
# 1. BAR CHART - Top 15 Countries by Confirmed Cases (FIXED)
# ==============================================================================

# Sort and get top 15 countries
top_countries <- head(country_wise_latest[order(-country_wise_latest$Confirmed), ], 15)

# Create color gradient
colors_bar <- colorRampPalette(c("steelblue", "darkblue"))(15)

par(mar = c(7, 6, 4, 2))  # Increased left margin from 5 to 6
barplot(top_countries$Confirmed,
        names.arg = top_countries$`Country/Region`,
        col = colors_bar,
        main = "Top 15 Countries by Total Confirmed COVID-19 Cases",
        xlab = "",
        ylab = "Confirmed Cases",
        las = 2,
        cex.names = 0.8,
        cex.axis = 0.9,
        ylim = c(0, max(top_countries$Confirmed) * 1.1),
        mgp = c(4, 1, 0))  # Added mgp to move y-axis label further from axis
mtext("Country", side = 1, line = 5.5, cex = 1)
# Add value labels on top of bars
text(x = seq(0.7, by = 1.2, length.out = 15),
     y = top_countries$Confirmed,
     labels = format(top_countries$Confirmed, big.mark = ","),
     pos = 3, cex = 0.7, col = "black")


# ==============================================================================
# 2. PIE CHART - Distribution of Cases by WHO Region
# ==============================================================================

# Aggregate data by WHO Region
region_data <- aggregate(Confirmed ~ `WHO Region`, data = country_wise_latest, sum)
region_data <- region_data[order(-region_data$Confirmed), ]

# Calculate percentages
pct <- round(region_data$Confirmed / sum(region_data$Confirmed) * 100, 1)
labels <- paste(region_data$`WHO Region`, "\n", pct, "%", sep = "")

# Color palette
colors_pie <- c("#FF6B6B", "#4ECDC4", "#45B7D1", "#FFA07A", "#98D8C8", "#FFD93D")

par(mar = c(2, 2, 4, 2))
pie(region_data$Confirmed,
    labels = labels,
    col = colors_pie,
    main = "Distribution of Confirmed Cases by WHO Region",
    cex = 0.9,
    radius = 1)


# ==============================================================================
# 3. HISTOGRAM - Distribution of Death Rates (Deaths/100 Cases)
# ==============================================================================

# Remove outliers for better visualization
death_rates <- country_wise_latest$`Deaths / 100 Cases`
death_rates <- death_rates[death_rates < 20]  # Filter extreme outliers

par(mar = c(5, 5, 4, 2))
hist(death_rates,
     breaks = 30,
     col = "coral",
     border = "white",
     main = "Distribution of COVID-19 Death Rates Across Countries",
     xlab = "Death Rate (Deaths per 100 Cases)",
     ylab = "Number of Countries",
     las = 1,
     cex.main = 1.2,
     cex.lab = 1)
abline(v = mean(death_rates, na.rm = TRUE), col = "darkred", lwd = 2, lty = 2)
legend("topright",
       legend = c(paste("Mean:", round(mean(death_rates, na.rm = TRUE), 2))),
       col = "darkred", lty = 2, lwd = 2, cex = 0.9)


# ==============================================================================
# 4. STACKED BAR CHART - Top 10 Countries: Active/Recovered/Deaths (FIXED)
# ==============================================================================

# Get top 10 countries and prepare data
top10 <- head(country_wise_latest[order(-country_wise_latest$Confirmed), ], 10)
stack_data <- as.matrix(t(top10[, c("Active", "Recovered", "Deaths")]))

par(mar = c(8, 6, 4, 8))  # Increased left margin from 5 to 6
barplot(stack_data,
        col = c("#FFD93D", "#6BCF7F", "#FF6B6B"),
        names.arg = top10$`Country/Region`,
        main = "COVID-19 Case Distribution in Top 10 Countries",
        xlab = "",
        ylab = "Number of Cases",
        las = 2,
        cex.names = 0.8,
        mgp = c(4.5, 1, 0),  # Added mgp to move y-axis label further from axis
        legend.text = c("Active", "Recovered", "Deaths"),
        args.legend = list(x = "topright",
                           inset = c(-0.15, 0),
                           xpd = TRUE,
                           cex = 0.9,
                           bty = "n"))
mtext("Country", side = 1, line = 6.5, cex = 1)


# ==============================================================================
# 5. SCATTER PLOT - Death Rate vs Recovery Rate
# ==============================================================================

# Filter data for better visualization
plot_data <- country_wise_latest[country_wise_latest$Confirmed > 1000, ]

# Create color by WHO Region
region_colors <- c("Eastern Mediterranean" = "#FF6B6B",
                   "Europe" = "#4ECDC4",
                   "Africa" = "#45B7D1",
                   "Americas" = "#FFA07A",
                   "South-East Asia" = "#98D8C8",
                   "Western Pacific" = "#FFD93D")

par(mar = c(5, 5, 4, 8))
plot(plot_data$`Recovered / 100 Cases`,
     plot_data$`Deaths / 100 Cases`,
     col = region_colors[plot_data$`WHO Region`],
     pch = 19,
     cex = 1.2,
     main = "Death Rate vs Recovery Rate (Countries with >1000 cases)",
     xlab = "Recovery Rate (Recovered per 100 Cases)",
     ylab = "Death Rate (Deaths per 100 Cases)",
     xlim = c(0, 100),
     ylim = c(0, 20),
     cex.main = 1.1,
     cex.lab = 1)
grid(col = "lightgray", lty = "dotted")
legend("topright",
       legend = names(region_colors),
       col = region_colors,
       pch = 19,
       cex = 0.7,
       inset = c(-0.25, 0),
       xpd = TRUE,
       bty = "n")


# ==============================================================================
# 6. BOX PLOT - Death Rates by WHO Region
# ==============================================================================

par(mar = c(8, 5, 4, 2))
boxplot(`Deaths / 100 Cases` ~ `WHO Region`,
        data = country_wise_latest[country_wise_latest$`Deaths / 100 Cases` < 20, ],
        col = c("#FF6B6B", "#4ECDC4", "#45B7D1", "#FFA07A", "#98D8C8", "#FFD93D"),
        main = "Death Rate Distribution by WHO Region",
        xlab = "",
        ylab = "Death Rate (Deaths per 100 Cases)",
        las = 2,
        cex.axis = 0.8,
        cex.main = 1.2,
        outline = TRUE)
mtext("WHO Region", side = 1, line = 6.5, cex = 1)
abline(h = median(country_wise_latest$`Deaths / 100 Cases`, na.rm = TRUE),
       col = "red", lty = 2, lwd = 1.5)


# ==============================================================================
# 7. LINE CHART - Week-over-Week Growth Rate (Top 15 Countries)
# ==============================================================================

# Get top 15 by confirmed cases
top15_growth <- head(country_wise_latest[order(-country_wise_latest$Confirmed), ], 15)
top15_growth <- top15_growth[order(top15_growth$`1 week % increase`), ]

par(mar = c(5, 10, 4, 2))
barplot(top15_growth$`1 week % increase`,
        names.arg = top15_growth$`Country/Region`,
        col = ifelse(top15_growth$`1 week % increase` > 10, "tomato", "lightgreen"),
        main = "Week-over-Week Growth Rate (Top 15 Countries)",
        xlab = "Growth Rate (%)",
        ylab = "",
        horiz = TRUE,
        las = 1,
        cex.names = 0.8,
        cex.axis = 0.9)
abline(v = 10, col = "darkred", lty = 2, lwd = 2)
legend("bottomright",
       legend = c("> 10% (High Growth)", "< 10% (Low Growth)", "10% Threshold"),
       fill = c("tomato", "lightgreen", NA),
       border = c("black", "black", NA),
       lty = c(NA, NA, 2),
       lwd = c(NA, NA, 2),
       col = c(NA, NA, "darkred"),
       cex = 0.8,
       bty = "n")


# ==============================================================================
# SUMMARY STATISTICS
# ==============================================================================

cat("\n=== COVID-19 Data Summary ===\n")
cat("Total Countries:", nrow(country_wise_latest), "\n")
cat("Total Confirmed Cases:", format(sum(country_wise_latest$Confirmed), big.mark = ","), "\n")
cat("Total Deaths:", format(sum(country_wise_latest$Deaths), big.mark = ","), "\n")
cat("Total Recovered:", format(sum(country_wise_latest$Recovered, na.rm = TRUE), big.mark = ","), "\n")
cat("Global Death Rate:", round(sum(country_wise_latest$Deaths) / sum(country_wise_latest$Confirmed) * 100, 2), "%\n")
cat("Global Recovery Rate:", round(sum(country_wise_latest$Recovered, na.rm = TRUE) / sum(country_wise_latest$Confirmed) * 100, 2), "%\n")
