Tambouille.controllers :profile, :parent => :netboot do

  get :show, :with => [:profile_id, :filename] do
    @base_url = "http://10.191.1.252"

    @node = Node.load_from_macaddress(params[:netboot_id])

    profile_id = /^([a-z_0-9]+)$/.match(params[:profile_id]).to_s
    filename = /^([a-z_0-9]+)$/.match(params[:filename]).to_s

    content_type 'text/plain;charset=utf8'
    render "profile/" + profile_id + "/" + filename
  end

end
