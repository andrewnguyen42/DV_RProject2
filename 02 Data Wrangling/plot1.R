df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from EXOPLANETS where (MSTAR is not null and MASS is not null and SEP is not null)"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_cdt932', PASS='orcl_cdt932', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))


require(extrafont)
ggplot() +
    coord_cartesian() +
    scale_x_continuous() +
    scale_y_continuous() +
    labs(title='Countries') +
    labs(x="Mass of Star", y=paste("Mass of planet")) +
    layer(data=df,
        mapping=aes(x=as.numeric(as.character(MSTAR)), y=as.numeric(as.character(MASS)), color=as.numeric(as.character(SEP))),
        stat="identity",
        stat_params=list(),
        geom="point",
        geom_params=list(),
        position=position_jitter(width=0, height=0)
    )
