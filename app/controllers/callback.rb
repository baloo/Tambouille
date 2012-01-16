Tambouille.controllers :callback, :parent => :netboot do

  get :trigger, :with => [:trigger_name] do
    "Triggered #{params[:netboot_id]} #{params[:trigger_name]}"
  end

  get :config, :with => [:config_name] do
    "config #{params[:netboot_id]} #{params[:config_name]}"
  end

end
