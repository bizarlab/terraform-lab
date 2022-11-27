resource "oci_core_instance" "windows_instance" {

    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    compartment_id = "Compartment donde lo vamos a instalar"
    shape = "VM.Standard.E4.Flex"
    shape_config {
    ocpus = 2
    memory_in_gbs = 16
    #admin_username = var.admin_username
    #admin_password = var.admin_username
    }
    source_details {
        #source_id = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaaoffnm7opezqbhzln3u4lzv6ujteag5h7oxcsio3kr35sp7mlamcq"
        #source_id = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaandftbicox5dje7ufgporxov4o3wckbu5mxw27tyjxolekjwrcgsq"
        source_id = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa77j4rsjiu4m3ijk762dhaxqs65o2wy6jzxs3circiplykbjtzo2q"
        source_type = "image"
        boot_volume_size_in_gbs = 100
    }

    display_name = "spyro12c"
    create_vnic_details {

        assign_public_ip = false
        subnet_id = "OCID SUBNET"
    }
    extended_metadata = {
        ssh_authorized_keys = file("/home/oracle/.ssh/id_rsa_terraform.pub")
    }
    preserve_boot_volume = false
}
resource "oci_core_volume" "CreateVolume"{

        availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
        compartment_id = "COMPARTMENT OCID"
        display_name = "oradata"
        size_in_gbs = 100
}

resource "oci_core_volume_attachment" "CreateVolumeAttachment"{

        attachment_type = "iscsi"
        instance_id = oci_core_instance.windows_instance.id
        volume_id = oci_core_volume.CreateVolume.id
}
resource "oci_core_volume" "CreateVolume2"{

        availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
        compartment_id = "compartment ocid"
        display_name = "backup"
        size_in_gbs = 100
}
resource "oci_core_volume_attachment" "CreateVolumeAttachment2"{

        attachment_type = "iscsi"
        instance_id = oci_core_instance.windows_instance.id
        volume_id = oci_core_volume.CreateVolume2.id
}
