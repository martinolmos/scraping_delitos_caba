# Carga las librerías necesarias
library(httr)
library(readxl)

# url base
burl <- "https://mapa.seguridadciudad.gob.ar/api/index.php/reporte"

# Vector con los delitos y el respectivo código de la api
tipo <- c(hurto_automotor = 3, 
          robo_automotor = 10, 
          lesiones_vial = 16, 
          homi_dol = 18, 
          homi_vial = 17, 
          robo = 9, 
          hurto = 2)

# Elimina "mydata" en caso de existir, para poder ser utilizado en el loop
if(exists("mydata")) {rm(mydata)}

# Loop sobre los delitos
for(i in 1:7) {
        
        # Loop sobre los doce meses
        for(j in 1:12) {
                
                # Loop sobre los dos años (2016 y 2017)
                for(anio in 2016:2017) {
                        
                        # Modifica la url para hacer el requerimiento a la api
                        murl <- modify_url(url = burl, 
                                           query = list(grupo = "undefined", 
                                                        tipo = tipo[i], 
                                                        mes = j, 
                                                        anio = as.character(anio), 
                                                        detalle = "true"))
                        
                        # Nombre del archivo a descargar
                        destfile <- paste0(names(tipo[i]), "_", j, "_", as.character(anio), ".xls")
                        
                        # Descarga el archivo                        #
                        file <- download.file(url = murl, 
                                              destfile = destfile,
                                              mode = "wb")
                        
                        # Lee los datos del archivo
                        temp <- read_xls(path = destfile, sheet = 1)
                        
                        # Agrega los datos al final del objeto "mydata"
                        if(!exists("mydata")) {
                                mydata <- temp
                                } else {
                                        mydata <- rbind(mydata, temp)
                                }
                        
                        # Elimina el archivo
                        file.remove(destfile)
                }
        }
}

# Guarda el objeto con todos los datos en un archivo
write.csv(x = mydata, file = "delitos_2016_2017.csv", row.names = FALSE)