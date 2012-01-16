# Helper methods defined here can be accessed in any controller or view in the application

Tambouille.helpers do
  def load_profile(profile_name, node)
    base_url = "http://${next-server}"

    case profile_name
    when "debian_squeeze"
      return {
      :tpl_name => :kernel_initrd,
      :kernel_options => [
        # Where we may get the kernel from
        base_url + "/static/debian/squeeze-zenexity/debian-installer/amd64/linux",

        # Where we should download preseed from
        "preseed/url=" + 
            base_url + 
            url(:profile, :show, node.macaddress, profile_name, "preseed"),

        # Configurations not available yet at startup
        "netcfg/get_hostname="+ node[:hostname],
        "netcfg/get_domain="+   node[:domain],

        # interface node should use
        "netcfg/choose_interface=eth1",

        # db_set seen * true
        # Avoid asking questions
        "auto=true"
      ],
      :initrd_options => [
        # Where we may get the initrd (yummy stuff) from
        base_url + 
          "/static/debian/squeeze_zenexity/debian-installer/amd64/initrd.gz"
      ]
    }
    when "debian_squeeze_zenexity"
      return {
        :tpl_name => :kernel_initrd,
        :kernel_options => [
          # Where we may get the kernel from
          base_url + "/static/debian/debian-squeeze-zenexity/debian-installer/amd64/linux",

          # Where we should download preseed from
          "preseed/url=" + 
              base_url + 
              url(:profile, :show, node.macaddress, profile_name, "preseed"),

          # Configurations not available yet at startup
          "netcfg/get_hostname="+ node[:hostname],
          "netcfg/get_domain="+   node[:domain],

          # interface node should use
          "netcfg/choose_interface=eth1",

          # db_set seen * true
          # Avoid asking questions
          "auto=true"
        ],
        :initrd_options => [
          # Where we may get the initrd (yummy stuff) from
          base_url + 
            "/static/debian/debian-squeeze-zenexity/debian-installer/amd64/initrd.gz"
        ]
      }
    when "normal-boot"
      return {
        :tpl_name => :normal_boot,
        :pre_commands => ["exit"]
      }
    when "loop"
      return {
        :tpl_name => :loop
      }
    else
      load_profile("loop", node)
    end


  end
end
