library(httr)
library(readxl)

burl <- "https://mapa.seguridadciudad.gob.ar/api/index.php/reporte"

tipo <- c(hurto_automotor = 3, 
          robo_automotor = 10, 
          lesiones_vial = 16, 
          homi_dol = 18, 
          homi_vial = 17, 
          robo = 9, 
          hurto = 2)

for(i in 1:7) {
        for(j in 1:12) {
                for(anio in 2016:2017) {
                        murl <- modify_url(url = burl, 
                                           query = list(grupo = "undefined", 
                                                        tipo = tipo[i], 
                                                        mes = j, 
                                                        anio = as.character(anio), 
                                                        detalle = "true"))
                        file <- download.file(url = murl, 
                                              destfile = paste0(names(tipo[i]), "_", j, "_2017.xls"),
                                              mode = "wb")
                        temp <- read_xls(path = paste0(names(tipo[i]), "_", j, "_2017.xls"), sheet = 1)
                        if(!exists("mydata")) {
                                mydata <- temp
                                } else {
                                        mydata <- rbind(mydata, temp)
                                }
                }
        }
        }

write.csv(x = mydata, file = "delitos_2016_2017.csv", row.names = FALSE)