Tambouille.controllers :netboot do
  get :show, :map => "/netboot/:netboot_id" do

    @node = Node.load_from_macaddress(params[:netboot_id])
    #@node[:boot_profile] = 'debian_squeeze_zenexity'
    #@node.save

    @profile = load_profile(@node[:boot_profile], @node)

    if @profile[:tpl_name] == :loop
      deliver(:netboot, :unknown_macaddress, params[:netboot_id])
    end

    content_type 'text/plain;charset=utf8'
    render "netboot/"+@profile[:tpl_name].to_s
  end
end
