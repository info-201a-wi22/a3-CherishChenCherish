library(tidyverse)
data <- read_csv("incarceration_trends.csv")

# Summary Statisitc
nobs <- nrow(data)
num_variables <- ncol(data)

min_year <- min(data$year)
max_year <- max(data$year)
data2018 <- data %>% filter(year==2018)
avg_total_jail_pop <- mean(data2018$total_jail_pop, na.rm=T)

highest_record <- data2018 %>% arrange(desc(total_jail_pop)) %>% head(1)
highest_record


lowest_record <- data2018 %>% arrange(total_jail_pop) %>% head(1)
lowest_record

top5states <- data2018 %>% group_by(state) %>% 
  summarise(total_jail_pop=sum(total_jail_pop, na.rm=T)) %>% arrange(desc(total_jail_pop)) %>%
  head(5)

# Trend Line
data1 <- data %>% mutate(white_prison_pop=replace_na(white_prison_pop, 0),
                         black_prison_pop=replace_na(black_prison_pop, 0),
                         latinx_prison_pop=replace_na(latinx_prison_pop, 0),
                         aapi_prison_pop=replace_na(aapi_prison_pop, 0),
                         native_prison_pop=replace_na(native_prison_pop, 0),
                         white_jail_pop=replace_na(white_jail_pop, 0),
                         black_jail_pop=replace_na(black_jail_pop, 0),
                         latinx_jail_pop=replace_na(latinx_jail_pop, 0),
                         aapi_jail_pop=replace_na(aapi_jail_pop, 0),
                         native_jail_pop=replace_na(native_jail_pop, 0)
) %>%
  group_by(year) %>% summarise(
    White=sum(white_prison_pop + white_jail_pop),
    Black=sum(black_prison_pop + black_jail_pop),
    Latinx=sum(latinx_prison_pop + latinx_jail_pop),
    AAPI=sum(aapi_prison_pop + aapi_jail_pop),
    Native=sum(native_prison_pop + native_jail_pop)
  ) %>% gather(key=Race, value=Pop, -year) %>% 
  mutate(Race=factor(Race, levels = c("White", "Black", "Latinx", "AAPI", "Native")))
plot1  <- ggplot(data=data1, aes(x=year, y=Pop, color=Race)) +  geom_line() +
  geom_point() + 
  labs(x="Year", y="Population", title="Incarerated Population Over Time")
plot1

# Comparasion
data2 <- data %>% 
  filter(year==2016) %>%
  mutate(female_jail_pop=replace_na(female_jail_pop, 0),
         male_jail_pop=replace_na(male_jail_pop, 0),
         female_prison_pop=replace_na(female_prison_pop, 0),
         male_prison_pop=replace_na(male_prison_pop, 0)
         ) %>%
  select(yfips, female_jail_pop, male_jail_pop, female_prison_pop,
         male_prison_pop) 

data2.female <- data2 %>% select(yfips, female_jail_pop, female_prison_pop)
data2.male <- data2 %>% select(yfips, male_jail_pop, male_prison_pop)
colnames(data2.female) <- c("yfips", "jail", "prison")
colnames(data2.male) <- c("yfips", "jail", "prison")
data2.female$gender <- "female"
data2.male$gender <- "male"
data2 <- rbind(data2.female, data2.male)

plot2 <- ggplot(data2, aes(x=jail, y=prison, color=gender)) + geom_point() +
  facet_wrap(~gender, scales = "free") +
  geom_smooth(method="lm") +
  labs(x="Jail Population", y="Prison Population",
       title="Prison population by Jail Population")
plot2

# Map
library(maps)
incarceration_county <-  data %>% filter(state=="CA") %>% filter(year==2018) %>% 
  mutate(
    total_prison_pop=replace_na(total_prison_pop, 0),
    total_jail_pop=replace_na(total_jail_pop, 0)
  )  %>% mutate(
    Pop=total_prison_pop+total_jail_pop
  ) %>% select(fips, Pop)

fips <- county.fips  %>% separate(polyname, into=c("state", "subregion"), sep=",") %>%
  filter(state=="california")
fips <- fips[!duplicated(fips$fips), ]
incarceration_county <- left_join(incarceration_county, fips)


county <- map_data("county")
ca_county <- county %>% filter(region=="california")
map_data  <- left_join(ca_county, incarceration_county)
plot3 <- ggplot(map_data, aes(x=long, y=lat, fill=Pop, group=subregion)) + geom_polygon() +
  scale_fill_distiller(palette = "YlOrBr") + theme_light() +
  labs(x="", y="", title="Incarceration Populaation in CA (2018)", fill="Population")
plot3
