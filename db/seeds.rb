# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

user = User.find_or_create_by!(email: "dev@example.com") do |u|
  u.username = "pluto"
  u.password = "password"
  u.password_confirmation = "password"
end

puts "Seeding 50 sample companies..."

companies_data = [
  # Technology
  { company_name: "NovaTech Solutions GmbH", address: "Innovationsstraße 123", city: "Berlin", country: "Germany", description: "Enterprise software solutions for cloud computing", revenue: 45_000_000, owner: "Sarah Müller", employees: 320, sector: "Technology", sub_sector: "Enterprise Software", website: "https://novatech.de", founded_year: 2015 },
  { company_name: "DataStream Analytics GmbH", address: "Datenweg 456", city: "Munich", country: "Germany", description: "Big data analytics and machine learning platform", revenue: 28_000_000, owner: "Michael Schmidt", employees: 180, sector: "Technology", sub_sector: "Data Analytics", website: "https://datastream.de", founded_year: 2018 },
  { company_name: "CyberShield Security AG", address: "Sicherheitsallee 789", city: "Frankfurt", country: "Germany", description: "Cybersecurity solutions for enterprises", revenue: 52_000_000, owner: "Jonas Weber", employees: 410, sector: "Technology", sub_sector: "Cybersecurity", website: "https://cybershield.de", founded_year: 2012 },
  { company_name: "CloudNine Infrastructure GmbH", address: "Wolkenstraße 321", city: "Hamburg", country: "Germany", description: "Cloud infrastructure and hosting services", revenue: 67_000_000, owner: "Emily Fischer", employees: 290, sector: "Technology", sub_sector: "Cloud Services", website: "https://cloudnine.de", founded_year: 2014 },
  { company_name: "PixelPerfect Design GmbH", address: "Kreativweg 555", city: "Cologne", country: "Germany", description: "UI/UX design agency for tech startups", revenue: 8_500_000, owner: "David Hoffmann", employees: 65, sector: "Technology", sub_sector: "Design Services", website: "https://pixelperfect.de", founded_year: 2019 },

  # Healthcare
  { company_name: "MedCore Diagnostik GmbH", address: "Medizinplatz 100", city: "Heidelberg", country: "Germany", description: "Advanced diagnostic equipment manufacturer", revenue: 125_000_000, owner: "Dr. Amanda Bauer", employees: 850, sector: "Healthcare", sub_sector: "Medical Devices", website: "https://medcore.de", founded_year: 2008 },
  { company_name: "BioGenix Pharma AG", address: "Pharmaweg 200", city: "Leverkusen", country: "Germany", description: "Biopharmaceutical research and drug development", revenue: 340_000_000, owner: "Dr. Robert Klein", employees: 1200, sector: "Healthcare", sub_sector: "Pharmaceuticals", website: "https://biogenix.de", founded_year: 2005 },
  { company_name: "GesundheitErst Kliniken GmbH", address: "Wellnessallee 300", city: "Düsseldorf", country: "Germany", description: "Network of primary care clinics", revenue: 78_000_000, owner: "Dr. Lisa Wagner", employees: 620, sector: "Healthcare", sub_sector: "Healthcare Services", website: "https://gesundheiterst.de", founded_year: 2010 },
  { company_name: "TeleHealth Connect GmbH", address: "Digitalstraße 400", city: "Stuttgart", country: "Germany", description: "Telemedicine platform connecting patients with doctors", revenue: 22_000_000, owner: "Jennifer Braun", employees: 145, sector: "Healthcare", sub_sector: "Digital Health", website: "https://telehealthconnect.de", founded_year: 2017 },
  { company_name: "SeniorenPflege GmbH", address: "Pflegeweg 500", city: "Nuremberg", country: "Germany", description: "Home healthcare services for seniors", revenue: 35_000_000, owner: "Thomas Schneider", employees: 480, sector: "Healthcare", sub_sector: "Home Healthcare", website: "https://seniorenpflege.de", founded_year: 2011 },

  # Finance
  { company_name: "KapitalEdge Investments GmbH", address: "Börsenstraße 1", city: "Frankfurt", country: "Germany", description: "Investment management and wealth advisory", revenue: 89_000_000, owner: "Richard Goldmann", employees: 220, sector: "Finance", sub_sector: "Investment Management", website: "https://kapitaledge.de", founded_year: 2009 },
  { company_name: "FinTech Dynamics GmbH", address: "Finanzplatz 250", city: "Berlin", country: "Germany", description: "Digital banking and payment solutions", revenue: 156_000_000, owner: "Emma Richter", employees: 780, sector: "Finance", sub_sector: "FinTech", website: "https://fintechdynamics.de", founded_year: 2013 },
  { company_name: "SecureBank Holding AG", address: "Bankweg 500", city: "Munich", country: "Germany", description: "Commercial and retail banking services", revenue: 420_000_000, owner: "Wilhelm Lang", employees: 2100, sector: "Finance", sub_sector: "Banking", website: "https://securebank.de", founded_year: 1998 },
  { company_name: "VersicherungRecht Gruppe", address: "Versicherungsallee 75", city: "Cologne", country: "Germany", description: "Property and casualty insurance provider", revenue: 245_000_000, owner: "Patricia Krause", employees: 890, sector: "Finance", sub_sector: "Insurance", website: "https://versicherungrecht.de", founded_year: 2001 },
  { company_name: "KryptoTresor Exchange GmbH", address: "Blockchainstraße 888", city: "Berlin", country: "Germany", description: "Cryptocurrency exchange and custody services", revenue: 67_000_000, owner: "Marcus Werner", employees: 185, sector: "Finance", sub_sector: "Cryptocurrency", website: "https://kryptotresor.de", founded_year: 2019 },

  # Manufacturing
  { company_name: "StahlSchmiede Industrie AG", address: "Industriepark 1000", city: "Essen", country: "Germany", description: "Steel manufacturing and metal fabrication", revenue: 380_000_000, owner: "Johann Meier", employees: 2400, sector: "Manufacturing", sub_sector: "Steel & Metals", website: "https://stahlschmiede.de", founded_year: 1985 },
  { company_name: "AutoTeile Global GmbH", address: "Montagestraße 2000", city: "Wolfsburg", country: "Germany", description: "Automotive parts manufacturing", revenue: 520_000_000, owner: "Franz Becker", employees: 3200, sector: "Manufacturing", sub_sector: "Automotive", website: "https://autoteileglobal.de", founded_year: 1972 },
  { company_name: "PräzisionsTech Maschinenbau GmbH", address: "Präzisionsweg 150", city: "Munich", country: "Germany", description: "High-precision CNC machining services", revenue: 95_000_000, owner: "Hans Zimmermann", employees: 520, sector: "Manufacturing", sub_sector: "Precision Engineering", website: "https://praezisionstech.de", founded_year: 1995 },
  { company_name: "GrünPack Solutions GmbH", address: "Ökostraße 300", city: "Freiburg", country: "Germany", description: "Sustainable packaging manufacturing", revenue: 42_000_000, owner: "Anna Vogel", employees: 280, sector: "Manufacturing", sub_sector: "Packaging", website: "https://gruenpack.de", founded_year: 2016 },
  { company_name: "ElektroMontage GmbH", address: "Schaltkreisweg 500", city: "Dresden", country: "Germany", description: "Electronics assembly and PCB manufacturing", revenue: 185_000_000, owner: "Chen Wei", employees: 1800, sector: "Manufacturing", sub_sector: "Electronics", website: "https://elektromontage.de", founded_year: 2007 },

  # Retail
  { company_name: "UrbanStyle Mode GmbH", address: "Modeallee 100", city: "Berlin", country: "Germany", description: "Contemporary fashion retail chain", revenue: 156_000_000, owner: "Sofia Lorenz", employees: 1200, sector: "Retail", sub_sector: "Fashion", website: "https://urbanstyle.de", founded_year: 2011 },
  { company_name: "FrischMarkt Lebensmittel GmbH", address: "Marktstraße 200", city: "Bremen", country: "Germany", description: "Organic and local grocery stores", revenue: 89_000_000, owner: "Daniel Grün", employees: 720, sector: "Retail", sub_sector: "Grocery", website: "https://frischmarkt.de", founded_year: 2008 },
  { company_name: "TechZone Elektronik GmbH", address: "Gadgetweg 300", city: "Hamburg", country: "Germany", description: "Consumer electronics retail", revenue: 234_000_000, owner: "Takeshi Tanaka", employees: 1450, sector: "Retail", sub_sector: "Electronics", website: "https://techzone.de", founded_year: 2003 },
  { company_name: "HeimStil Einrichtung GmbH", address: "Dekorstraße 400", city: "Leipzig", country: "Germany", description: "Modern furniture and home decor", revenue: 178_000_000, owner: "Erik Lindner", employees: 980, sector: "Retail", sub_sector: "Home & Garden", website: "https://heimstil.de", founded_year: 2006 },
  { company_name: "SportGipfel Ausrüstung GmbH", address: "Abenteuerweg 500", city: "Garmisch-Partenkirchen", country: "Germany", description: "Outdoor sports equipment and apparel", revenue: 67_000_000, owner: "Rachel Berger", employees: 420, sector: "Retail", sub_sector: "Sporting Goods", website: "https://sportgipfel.de", founded_year: 2012 },

  # Energy
  { company_name: "SolarWelle Energie GmbH", address: "Sonnenlichtweg 100", city: "Freiburg", country: "Germany", description: "Solar panel installation and energy services", revenue: 145_000_000, owner: "Markus Sommer", employees: 680, sector: "Energy", sub_sector: "Solar", website: "https://solarwelle.de", founded_year: 2010 },
  { company_name: "WindKraft Dynamik GmbH", address: "Turbinenstraße 200", city: "Bremerhaven", country: "Germany", description: "Wind turbine manufacturing and maintenance", revenue: 320_000_000, owner: "Lars Nielsen", employees: 1100, sector: "Energy", sub_sector: "Wind", website: "https://windkraft.de", founded_year: 2004 },
  { company_name: "PetroMax Ressourcen AG", address: "Ölfeld Straße 300", city: "Hanover", country: "Germany", description: "Oil and gas exploration and production", revenue: 890_000_000, owner: "Wilhelm Koch", employees: 3500, sector: "Energy", sub_sector: "Oil & Gas", website: "https://petromax.de", founded_year: 1978 },
  { company_name: "NetzSmart Versorger GmbH", address: "Stromweg 400", city: "Dortmund", country: "Germany", description: "Smart grid technology and energy management", revenue: 78_000_000, owner: "Nancy Braun", employees: 340, sector: "Energy", sub_sector: "Utilities", website: "https://netzsmart.de", founded_year: 2015 },
  { company_name: "WasserKraft Energie GmbH", address: "Dammstraße 500", city: "Passau", country: "Germany", description: "Hydroelectric power generation", revenue: 210_000_000, owner: "Otto Hansen", employees: 420, sector: "Energy", sub_sector: "Hydroelectric", website: "https://wasserkraft.de", founded_year: 1992 },

  # Real Estate
  { company_name: "StadtEntwickler AG", address: "Skyline Tower 1", city: "Frankfurt", country: "Germany", description: "Commercial real estate development", revenue: 450_000_000, owner: "Georg Hamilton", employees: 380, sector: "Real Estate", sub_sector: "Commercial Development", website: "https://stadtentwickler.de", founded_year: 1995 },
  { company_name: "HausBauer Allianz GmbH", address: "Wohnstraße 200", city: "Munich", country: "Germany", description: "Residential home construction", revenue: 280_000_000, owner: "Maria Jung", employees: 1200, sector: "Real Estate", sub_sector: "Residential Construction", website: "https://hausbauer.de", founded_year: 2002 },
  { company_name: "ImmobilienErst Verwaltung GmbH", address: "Vermieterweg 300", city: "Berlin", country: "Germany", description: "Property management services", revenue: 45_000_000, owner: "Oliver Schwarz", employees: 290, sector: "Real Estate", sub_sector: "Property Management", website: "https://immobilienerst.de", founded_year: 2009 },
  { company_name: "LuxusAnwesen Makler GmbH", address: "Villenallee 400", city: "Baden-Baden", country: "Germany", description: "Luxury residential real estate brokerage", revenue: 32_000_000, owner: "Victoria König", employees: 85, sector: "Real Estate", sub_sector: "Luxury Real Estate", website: "https://luxusanwesen.de", founded_year: 2014 },
  { company_name: "IndustrieRaum Solutions GmbH", address: "Lagerweg 500", city: "Duisburg", country: "Germany", description: "Industrial and warehouse space leasing", revenue: 125_000_000, owner: "Robert Wolf", employees: 180, sector: "Real Estate", sub_sector: "Industrial", website: "https://industrieraum.de", founded_year: 2008 },

  # Transportation & Logistics
  { company_name: "SchnellLogistik AG", address: "Frachtstraße 100", city: "Leipzig", country: "Germany", description: "Freight and logistics services", revenue: 560_000_000, owner: "Karl Fracht", employees: 4200, sector: "Transportation", sub_sector: "Logistics", website: "https://schnelllogistik.de", founded_year: 1988 },
  { company_name: "AeroJet Fluglinien GmbH", address: "Flughafenallee 200", city: "Frankfurt", country: "Germany", description: "Regional airline services", revenue: 890_000_000, owner: "Janet Keller", employees: 5600, sector: "Transportation", sub_sector: "Aviation", website: "https://aerojet.de", founded_year: 1995 },
  { company_name: "OzeanFracht Schifffahrt AG", address: "Hafenstraße 300", city: "Hamburg", country: "Germany", description: "International container shipping", revenue: 1_200_000_000, owner: "Klaus Nordmann", employees: 3800, sector: "Transportation", sub_sector: "Maritime", website: "https://ozeanfracht.de", founded_year: 1975 },
  { company_name: "LetzteMeile Lieferung GmbH", address: "Expressweg 400", city: "Berlin", country: "Germany", description: "Same-day and last-mile delivery services", revenue: 78_000_000, owner: "Kevin Park", employees: 1800, sector: "Transportation", sub_sector: "Delivery Services", website: "https://letztemeile.de", founded_year: 2017 },
  { company_name: "SchienenConnect Transit GmbH", address: "Bahnhofsallee 500", city: "Mannheim", country: "Germany", description: "Rail freight transportation", revenue: 340_000_000, owner: "Friedrich Bahn", employees: 2100, sector: "Transportation", sub_sector: "Rail", website: "https://schienenconnect.de", founded_year: 1982 },

  # Media & Entertainment
  { company_name: "StreamVision Medien GmbH", address: "Studioplatz 100", city: "Munich", country: "Germany", description: "Streaming content production and distribution", revenue: 245_000_000, owner: "Alexandra Stern", employees: 890, sector: "Media", sub_sector: "Streaming", website: "https://streamvision.de", founded_year: 2015 },
  { company_name: "SpielSchmiede Studios GmbH", address: "Gamingstraße 200", city: "Berlin", country: "Germany", description: "Video game development studio", revenue: 120_000_000, owner: "Ryan Hartmann", employees: 450, sector: "Media", sub_sector: "Gaming", website: "https://spielschmiede.de", founded_year: 2012 },
  { company_name: "KlangWelle Records GmbH", address: "Musikweg 300", city: "Cologne", country: "Germany", description: "Music production and record label", revenue: 56_000_000, owner: "Michelle Roth", employees: 180, sector: "Media", sub_sector: "Music", website: "https://klangwelle.de", founded_year: 2008 },
  { company_name: "WerbeReich Marketing GmbH", address: "Agenturallee 400", city: "Düsseldorf", country: "Germany", description: "Digital advertising and marketing agency", revenue: 89_000_000, owner: "Christoph Mayer", employees: 320, sector: "Media", sub_sector: "Advertising", website: "https://werbereich.de", founded_year: 2011 },
  { company_name: "NachrichtenJetzt Netzwerk GmbH", address: "Sendezentrum 500", city: "Mainz", country: "Germany", description: "24-hour news broadcasting", revenue: 380_000_000, owner: "Katharina Engel", employees: 1400, sector: "Media", sub_sector: "Broadcasting", website: "https://nachrichtenjetzt.de", founded_year: 1998 },

  # Food & Beverage
  { company_name: "BauernFrisch Lebensmittel GmbH", address: "Landwirtschaftsweg 100", city: "Rostock", country: "Germany", description: "Organic food processing and distribution", revenue: 210_000_000, owner: "Samuel Bäcker", employees: 980, sector: "Food & Beverage", sub_sector: "Food Processing", website: "https://bauernfrisch.de", founded_year: 2005 },
  { company_name: "HandwerksBrau Kollektiv GmbH", address: "Brauereistraße 200", city: "Bamberg", country: "Germany", description: "Craft beer brewing and distribution", revenue: 45_000_000, owner: "Bernhard Hopfen", employees: 220, sector: "Food & Beverage", sub_sector: "Beverages", website: "https://handwerksbrau.de", founded_year: 2013 },
  { company_name: "GlobalGewürz Handel GmbH", address: "Gewürzmarkt 300", city: "Hamburg", country: "Germany", description: "Spice import and export", revenue: 78_000_000, owner: "Raj Patel", employees: 340, sector: "Food & Beverage", sub_sector: "Food Trading", website: "https://globalgewuerz.de", founded_year: 1995 },
  { company_name: "MeeresfrüchteDirekt GmbH", address: "Hafenfront 400", city: "Kiel", country: "Germany", description: "Seafood wholesale and distribution", revenue: 156_000_000, owner: "Antonio Fischer", employees: 580, sector: "Food & Beverage", sub_sector: "Seafood", website: "https://maborchte.de", founded_year: 2001 },
  { company_name: "GesundSnack GmbH", address: "Ernährungsallee 500", city: "Bonn", country: "Germany", description: "Healthy snack food manufacturing", revenue: 67_000_000, owner: "Jessica Müller", employees: 290, sector: "Food & Beverage", sub_sector: "Snack Foods", website: "https://gesundsnack.de", founded_year: 2016 }
]

companies_data.each do |company_attrs|
  Company.find_or_create_by!(company_name: company_attrs[:company_name]) do |company|
    company.assign_attributes(company_attrs)
  end
end

puts "Created #{Company.count} companies!"
