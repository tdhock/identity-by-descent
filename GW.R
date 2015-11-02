works_with_R("3.2.2", data.table="1.9.6")

ancestors <- fread("GWAncestorsTable.csv")
participants <- fread("GWparticipantsTable.csv")

chr22 <- fread("zcat quebecgenpop.ca/Download/data/Genos2012/chr22.txt.gz")
names(chr22)[-c(1:3)]
six.char.id.vec <- names(chr22)[-c(1:3)]

line.vec <- readLines("recodeID_20081219.txt")
group <- cumsum(line.vec=="")
page <- ceiling(group.vec/2+0.1)
line.df <- data.frame(data=gsub("\\s", "", line.vec), group, page)
not.empty <- subset(line.df, data != "")
lines.by.page <- split(not.empty, not.empty$page)

codes.by.page <- list()
for(page.str in names(lines.by.page)){
  page.lines <- lines.by.page[[page.str]]
  lines.by.group <- split(page.lines, page.lines$group)
  codes.by.page[[page.str]] <- 
    data.table(code=lines.by.group[[1]]$data,
               six.char.id=lines.by.group[[2]]$data)
}
codes <- do.call(rbind, codes.by.page)

setkey(codes, six.char.id)
codes[six.char.id.vec][is.na(code)]
stopifnot(six.char.id.vec %in% codes$six.char.id)
