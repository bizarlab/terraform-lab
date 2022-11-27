resource "oci_core_instance" "oracle_linux_instance" {

    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    compartment_id = "Introducir el OCID del compartment donde lo vamos a instalar"
    shape = "VM.Standard.E4.Flex"
    shape_config {
    ocpus = 4
    memory_in_gbs = 12
    }
    source_details {
        source_id = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaaa6bjmlse5m66ynvzdayahqwsn73fug6lh5gjxkcmabivvpzegdpa"
        source_type = "image"
        boot_volume_size_in_gbs = 50
    }

    display_name = "sdlapx01"
    create_vnic_details {
        assign_public_ip = false
        subnet_id = "OCID de la subnet"
    }
    extended_metadata = {
        ssh_authorized_keys = file("/home/oracle/.ssh/id_rsa_terraform.pub")
    }
    preserve_boot_volume = false
}
resource "oci_core_volume" "CreateVolume"{

        availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
        compartment_id = "Introducir el OCID del compartment donde lo vamos a instalar"
        display_name = "oradata-sdlapx01"
        size_in_gbs = 64
}

resource "oci_core_volume_attachment" "CreateVolumeAttachment"{

        attachment_type = "iscsi"
        instance_id = oci_core_instance.oracle_linux_instance.id
        volume_id = oci_core_volume.CreateVolume.id
}
resource "oci_core_volume" "CreateVolume2"{

        availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
        compartment_id = "Introducir el OCID del compartment donde lo vamos a instalar"
        display_name = "backup-sdlapx01"
        size_in_gbs = 128
}

resource "oci_core_volume_attachment" "CreateVolumeAttachment2"{

        attachment_type = "iscsi"
        instance_id = oci_core_instance.oracle_linux_instance.id
        volume_id = oci_core_volume.CreateVolume2.id
}
resource "null_resource" "remote-exec" {
  depends_on = [oci_core_instance.oracle_linux_instance]
  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = "${oci_core_instance.oracle_linux_instance.private_ip}"
      user        = "opc"
      private_key = file("/home/oracle/.ssh/id_rsa_terraform")
    }

    inline = [
        "sudo iscsiadm -m node -o new -T ${oci_core_volume_attachment.CreateVolumeAttachment.iqn} -p ${oci_core_volume_attachment.CreateVolumeAttachment.ipv4}:${oci_core_volume_attachment.CreateVolumeAttachment.port}",
        "sudo iscsiadm -m node -o update -T ${oci_core_volume_attachment.CreateVolumeAttachment.iqn}  -n node.startup -v automatic",
        "sudo iscsiadm -m node -T ${oci_core_volume_attachment.CreateVolumeAttachment.iqn} -p ${oci_core_volume_attachment.CreateVolumeAttachment.ipv4}:${oci_core_volume_attachment.CreateVolumeAttachment.port} -l",
        "sudo iscsiadm -m node -o new -T ${oci_core_volume_attachment.CreateVolumeAttachment2.iqn} -p ${oci_core_volume_attachment.CreateVolumeAttachment2.ipv4}:${oci_core_volume_attachment.CreateVolumeAttachment2.port}",
        "sudo iscsiadm -m node -o update -T ${oci_core_volume_attachment.CreateVolumeAttachment2.iqn}  -n node.startup -v automatic",
        "sudo iscsiadm -m node -T ${oci_core_volume_attachment.CreateVolumeAttachment2.iqn} -p ${oci_core_volume_attachment.CreateVolumeAttachment2.ipv4}:${oci_core_volume_attachment.CreateVolumeAttachment2.port} -l",
        #"sudo dnf update -y",
        "echo 'Introducir public key' >> /home/opc/.ssh/authorized_keys",

    ]
  }
