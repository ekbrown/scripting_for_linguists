library("tidyverse")
setwd("/pathway/to/dir")

times <- read_csv("times.csv") 
times %>% 
  ggplot(aes(package, sec))+
  geom_jitter(height = 0, width = 0.2)+
  geom_boxplot(alpha = 0.5)+
  # coord_cartesian(ylim=c(0, 1))+
  theme_minimal()+
  labs(x="")

m1 <- lm(sec ~ package, data = times)
aov(m1) %>% TukeyHSD()
