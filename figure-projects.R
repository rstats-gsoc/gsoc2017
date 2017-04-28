works_with_R(
  "3.3.3",
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

data.frame(mentors[, list(projects=.N), by=list(mentor)][order(mentor)])
