resource "oci_core_instance" "windows_instance" {

    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    compartment_id = "Introducir el OCID del compartment donde lo vamos a instalar"
    shape = "VM.Standard.E4.Flex"
    shape_config {
    ocpus = 1
    memory_in_gbs = 15
    }

    source_details {

        source_id = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaaoqdedtw4dsmnk735ibcxu53lb63dec5wknszysi5g5pqfe4slkla"
        source_type = "image"
        boot_volume_size_in_gbs = 100
    }

    display_name = "middlewarespyro"
    create_vnic_details {
        assign_public_ip = false
        subnet_id = "ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaa2cxb5r5ebdktaeyxvrovwu5abx2jhuymxi5v5yicq4odjruprbzq"
    }

    preserve_boot_volume = false

}
