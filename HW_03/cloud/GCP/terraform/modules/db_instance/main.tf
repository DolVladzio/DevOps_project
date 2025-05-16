#########################################################################
# RESOURCES
#########################################################################
resource "google_sql_database_instance" "instances" {
	for_each = { for db in var.database : db.name => db }

	name             = each.value.name
	database_version = "${upper(each.value.type)}_${each.value.version}"
	region           = var.region

	settings {
		tier = "db-g1-${each.value.size}"
		availability_type = length(each.value.zone) > 1 ? "REGIONAL" : "ZONAL"

		ip_configuration {
		ipv4_enabled    = true
		}
	}

	deletion_protection = false
}
#########################################################################
