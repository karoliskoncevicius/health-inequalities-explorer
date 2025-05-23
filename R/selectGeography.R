selectGeographyUI <- function(id) {
  selectizeInput(
    NS(id, "selectGeography"),
    label = NULL,
    # Default choice upload initial loading should be England ICBs
    choices = c("Integrated Care Boards" = "england_icb_shp"),
    multiple = FALSE
  )
}

selectGeographyServer <- function(id, selected) {
  moduleServer(id, function(input, output, session) {
    observeEvent(selected$region, {
      geography_choices <- switch(
        selected$region,
        "england" = c("Local Authorities" = "england_ltla_shp", "Integrated Care Boards" = "england_icb_shp"),
        "northern_ireland" = c("Councils" = "northern_ireland_ltla_shp", "Health and Social Care Trusts" = "northern_ireland_hsct_shp"),
        "scotland" = c("Council Areas" = "scotland_ltla_shp", "Health Boards" = "scotland_hb_shp"),
        "wales" = c("Local Authorities" = "wales_ltla_shp", "Local Health Boards" = "wales_lhb_shp"),
        
        "england_central" = c("Local Authorities" = "brc_central_shp", "Integrated Care Boards" = "brc_central_icb_shp"),
        "england_london" =  c("Local Authorities" = "brc_london_shp", "Integrated Care Boards" = "brc_london_icb_shp"),
        "england_north" = c("Local Authorities" = "brc_north_shp", "Integrated Care Boards" = "brc_north_icb_shp"),
        "england_south" =  c("Local Authorities" = "brc_south_shp", "Integrated Care Boards" = "brc_south_icb_shp"),
        "england_southeast" =  c("Local Authorities" = "brc_southeast_shp", "Integrated Care Boards" = "brc_southeast_icb_shp")
      )
      
      # Debug
      # print(geography_choices[1])
      
      # Render server side to minimise user load
      updateSelectizeInput(
        session,
        "selectGeography",
        choices = geography_choices,
        selected = geography_choices[2],
        server = TRUE
      )
    })
    
    observeEvent(input$selectGeography, {
      selected$geography <- input$selectGeography
    })
  })
}

selectGeographyTest <- function() {
  ui <- fluidPage(
    selectRegionUI("region_test"),
    selectGeographyUI("test"),
    textOutput("text")
  )
  server <- function(input, output, session) {
    selected <- reactiveValues(region = vector(), geography = vector())
    selectRegionServer("region_test", selected)
    selectGeographyServer("test", selected)
    
    output$text <- renderText({
      selected$geography
    })
  }
  shinyApp(ui, server)
}

# Examples
# selectGeographyTest()
