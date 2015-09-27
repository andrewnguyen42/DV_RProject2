df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from EXOPLANETS where (MASS is not NULL and Date is not NULL)"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_cdt932', PASS='orcl_cdt932', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))


require(extrafont)

ggplot(df,aes(x=MASS)) +
  geom_histogram(binwidth=0.5,colour="black",fill="white")+
  geom_density()


ggplot() +
  coord_cartesian() + 
  scale_x_continuous() +
  scale_y_log10() +
  layer(data=df,
    mapping=aes(x=as.numeric(as.character(DATE_0)),y=as.numeric(as.character(MASS)),color=PLANETDISCMETH),
    stat="identity",
    stat_params=list(),
    geom="point",
    geom_params=list(),
    position = position_jitter(width=0.5, height=0)
  )
