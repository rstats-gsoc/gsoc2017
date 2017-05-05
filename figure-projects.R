works_with_R(
  "3.3.3",
  "faizan-khan-iit/ggplot2@5fb99d0cece13239bbbc09c6b8a7da7f86ac58e2", 
  data.table="1.10.4")
projects <- fread("projects.csv")
projects[, project.id := 1:.N]
mentors <- projects[, {
  split.vec <- strsplit(mentors, split=",| and ")[[1]]
  no.space <- gsub("^ *| *$", "", split.vec)
  data.table(
    mentor=no.space,
    .SD)
}, by=list(project.id)]
mentors[, as.data.frame(table(c(mentor, student)))]

data.frame(mentors[, list(projects=.N), by=list(mentor)][order(mentor)])

first.years <- projects[, .SD[which.min(year)], by=list(student)]
students <- projects[, list(
  years=ifelse(length(year)==1, paste(year), paste0(min(year), "-", max(year))),
  projects=paste(project, collapse=",")
), by=list(student)]
cameback <- mentors[students, on=list(mentor=student), nomatch=0L]

(show.cameback <- unique(cameback[, list(
  student.project=substr(projects, 1, 15),
  years, person=mentor, year,
  project.mentored=substr(project, 1, 15))][order(
    years, student.project, person, year, project.mentored)]))

gg <- ggplot()+
  geom_bar(aes(factor(year)), data=projects)

year.counts <- projects[, list(count=.N), by=year][order(year)]
gg <- ggplot()+
  geom_point(aes(factor(year), count), data=year.counts)+
  geom_text(aes(
    factor(year), count, label=count,
    vjust=ifelse(count<10, -0.5, 1.5)), data=year.counts)

png("figure-projects.png", 5, 3, units="in", res=200)
print(gg)
dev.off()

