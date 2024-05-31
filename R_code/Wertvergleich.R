rm(list=ls())

#data <- read.csv("C:/Users/PC/Desktop/Modul11/BatDat4eTivityD/BatDat/BatADevA20220318.txt", header = TRUE, sep = " ")
data <- read.csv("Data/BatADevA20220318.txt", header = TRUE, sep = " ")
colnames(data) <- c("Voltage", "Current")

#create time variable
#assuming one observation per 8 seconds, makes 1800 obs have a runtime of 4 hours
library(dplyr)
data <- data %>% 
    mutate(
        time_sec = 8,
        time_sec_cum = cumsum(time_sec),
        time_hour = time_sec_cum/3600
    )

# Notwendige Bibliotheken laden
library(ggplot2)

# Daten einlesen
#file_path <- "test_data.txt"  # Pfad zur Daten-Datei
#data <- read.csv(file_path, header = TRUE, sep = " ")
#colnames(data) <- c("Time", "Voltage", "Current")

# Grenzwerte festlegen
voltage_min <- 5.8
voltage_max <- 10
current_min <- 0.1
current_max <- 0.15
capacity_limit <- 0.5  # Kapazität in Ah

# Kapazität berechnen
time_diff <- diff(data$Time)
current_avg <- (head(data$Current, -1) + tail(data$Current, -1)) / 2
actual_capacity <- sum(time_diff * current_avg) / 3600

# Grenzwerte überprüfen
voltage_pass <- all(data$Voltage >= voltage_min & data$Voltage <= voltage_max)
current_pass <- all(data$Current >= current_min & data$Current <= current_max)
capacity_pass <- actual_capacity >= capacity_limit

# Farbkodierung für Konsole (nur auf unterstützten Plattformen)
green <- function(text) paste0("\033[32m", text, "\033[39m")
red <- function(text) paste0("\033[31m", text, "\033[39m")

# Ergebnisse ausgeben
cat("\nTestbericht:\n")
cat(sprintf("Mindestkapazität: %.2f Ah\n", capacity_limit))
cat(sprintf("Ist-Kapazität: %.2f Ah\n", actual_capacity))
cat(sprintf("Kapazität: %s\n", ifelse(capacity_pass, green("Pass"), red("Fail"))))
cat("\n")
cat(sprintf("Spannungsgrenzen: %.1f V bis %.1f V\n", voltage_min, voltage_max))
cat(sprintf("Spannung: %s\n", ifelse(voltage_pass, green("Pass"), red("Fail"))))
cat("\n")
cat(sprintf("Stromgrenzen: %.1f A bis %.1f A\n", current_min, current_max))
cat(sprintf("Strom: %s\n", ifelse(current_pass, green("Pass"), red("Fail"))))
cat("\n")

p <- ggplot(data, aes(x = time_hour)) +
  geom_line(aes(y = Voltage, color = "Voltage (V)")) +
  geom_line(aes(y = Current * 10, color = "Current (A)")) +  # Strom-Werte skalieren, um sie sichtbar zu machen
  scale_y_continuous(
    name = "Voltage (V)",
    sec.axis = sec_axis(~./10, name = "Current (A)")  # Skalierung der Strom-Werte zurücksetzen
  ) +
  scale_color_manual(values = c("Voltage (V)" = "blue", "Current (A)" = "red")) +
  labs(x = "Time (s)", title = "Entladekurve") +
  theme_minimal() +
  theme(
    axis.title.y.left = element_text(color = "blue"),
    axis.title.y.right = element_text(color = "red"),
    legend.position = "bottom",
    legend.title = element_blank()
  )
p
# Plot anzeigen
print(p)
