file_path <- "./01 Data/exoplanets.csv"

df <- read.csv(file_path, stringsAsFactors = FALSE)

# Replace "." (i.e., period) with "_" in the column names.
names(df) <- gsub("\\.+", "_", names(df))
names(df)
df <- rename(df, A_0 = A)
df <- rename(df, DEC_0 = DEC)
df <- rename(df, NAME_0 = NAME)
df <- rename(df, STAR_0 = STAR)
df <- rename(df, BINARY_0 = BINARY)
df <- rename(df, DATE_0 = DATE)
df <- rename(df, DEPTH_0 = DEPTH)
df <- rename(df, H_0 = H)
df <- rename(df, I_0 = I)
df <- rename(df, K_0 = K)
df <- rename(df, PER_0 = PER)
df <- rename(df, R_0 = R)
df <- rename(df, SET_0 = SET)
df <- rename(df, TIMING_0 = TIMING)


# str(df) # Uncomment this and  run just the lines to here to get column types to use for getting the list of measures.

measures <- c("A","AUPPER","ALOWER","UA","AR","ARUPPER","ARLOWER","UAR","ASTROMETRY","B","BUPPER","BLOWER","UB","BIGOM","BIGOMUPPER","BIGOMLOWER","UBIGOM","BINARY","BMV","CHI2","DATE","DEC","DEC_STRING","DENSITY","DENSITYUPPER","DENSITYLOWER","UDENSITY","DEPTH","DEPTHUPPER","DEPTHLOWER","UDEPTH","DIST","DISTUPPER","DISTLOWER","UDIST","DR","DRUPPER","DRLOWER","UDR","DVDT","DVDTUPPER","DVDTLOWER","UDVDT","ECC","ECCUPPER","ECCLOWER","UECC","EOD","FE","FEUPPER","FELOWER","UFE","FREEZE_ECC","GAMMA","GAMMAUPPER","GAMMALOWER","UGAMMA","GL","GRAVITY","GRAVITYUPPER","GRAVITYLOWER","UGRAVITY","H","HD","HIPP","HR","I","IUPPER","ILOWER","UI","IMAGING","J","K","KUPPER","KLOWER","UK","KOI","KS","KP","LAMBDA","LAMBDAUPPER","LAMBDALOWER","ULAMBDA","LOGG","LOGGUPPER","LOGGLOWER","ULOGG","MASS","MASSUPPER","MASSLOWER","UMASS","MICROLENSING","MSINI","MSINIUPPER","MSINILOWER","UMSINI","MSTAR","MSTARUPPER","MSTARLOWER","UMSTAR","MULT","NCOMP","NOBS","OM","OMUPPER","OMLOWER","UOM","PAR","PARUPPER","PARLOWER","UPAR","PER","PERUPPER","PERLOWER","UPER","R","RUPPER","RLOWER","UR","RA","RHK","RHOSTAR","RHOSTARUPPER","RHOSTARLOWER","URHOSTAR","RMS","RR","RRUPPER","RRLOWER","URR","RSTAR","RSTARUPPER","RSTARLOWER","URSTAR","SAO","SE","SEDEPTHJ","SEDEPTHJUPPER","SEDEPTHJLOWER","USEDEPTHJ","SEDEPTHH","SEDEPTHHUPPER","SEDEPTHHLOWER","USEDEPTHH","SEDEPTHKS","SEDEPTHKSUPPER","SEDEPTHKSLOWER","USEDEPTHKS","SEDEPTHKP","SEDEPTHKPUPPER","SEDEPTHKPLOWER","USEDEPTHKP","SEDEPTH36","SEDEPTH36UPPER","SEDEPTH36LOWER","USEDEPTH36","SEDEPTH45","SEDEPTH45UPPER","SEDEPTH45LOWER","USEDEPTH45","SEDEPTH58","SEDEPTH58UPPER","SEDEPTH58LOWER","USEDEPTH58","SEDEPTH80","SEDEPTH80UPPER","SEDEPTH80LOWER","USEDEPTH80","SEP","SEPUPPER","SEPLOWER","USEP","SET","SETUPPER","SETLOWER","USET","SHK","T0","T0UPPER","T0LOWER","UT0","T14","T14UPPER","T14LOWER","UT14","TEFF","TEFFUPPER","TEFFLOWER","UTEFF","TIMING","TRANSIT","TREND","TT","TTUPPER","TTLOWER","UTT","V","VSINI","VSINIUPPER","VSINILOWER","UVSINI","KEPID","KDE")
measures[measures == "A"] <- "A_0"
measures[measures == "DEC"] <- "DEC_0"
measures[measures == "NAME"] <- "NAME_0"
measures[measures == "STAR"] <- "STAR_0"
measures[measures == "BINARY"] <- "BINARY_0" 
measures[measures == "DATE"] <- "DATE_0" 
measures[measures == "DEPTH"] <- "DEPTH_0"
measures[measures == "H"] <- "H_0"
measures[measures == "I"] <- "I_0"
measures[measures == "K"] <- "K_0"
measures[measures == "PER"] <- "PER_0"
measures[measures == "R"] <- "R_0"
measures[measures == "SET"] <- "SET_0"
measures[measures == "TIMING"] <- "TIMING_0"

#measures <- NA # Do this if there are no measures.

# Get rid of special characters in each column.
# Google ASCII Table to understand the following:
for(n in names(df)) {
    df[n] <- data.frame(lapply(df[n], gsub, pattern="[^ -~]",replacement= ""))
}

dimensions <- setdiff(names(df), measures)
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    # Get rid of " and ' in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern="[\"']",replacement= ""))
    # Change & to and in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern="&",replacement= " and "))
    # Change : to ; in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern=":",replacement= ";"))
  }
}

library(lubridate)

# The following is an example of dealing with special cases like making state abbreviations be all upper case.
# df["State"] <- data.frame(lapply(df["State"], toupper))

# Get rid of all characters in measures except for numbers, the - sign, and period.dimensions
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    df[m] <- data.frame(lapply(df[m], gsub, pattern="[^--.0-9]",replacement= ""))
  }
}

write.csv(df, paste(gsub(".csv", "", file_path), ".reformatted.csv", sep=""), row.names=FALSE, na = "")

tableName <- gsub(" +", "_", gsub("[^A-z, 0-9, ]", "", gsub(".csv", "", file_path)))
sql <- paste("CREATE TABLE", tableName, "(\n-- Change table_name to the table name you want.\n")
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    sql <- paste(sql, paste(d, "varchar2(4000),\n"))
  }
}
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    if(m != tail(measures, n=1)) sql <- paste(sql, paste(m, "number(38,4),\n"))
    else sql <- paste(sql, paste(m, "number(38,4)\n"))
  }
}
sql <- paste(sql, ");")
cat(sql)
