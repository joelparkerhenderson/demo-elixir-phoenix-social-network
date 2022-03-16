mix phx.gen.html --binary-id \
  Posts Post posts \
    type_id:string \
    state_id:string \
    user_id:references:users \
    title:string \
    subtitle:string \
    summary:text \
    saga:text \
    image_uri:string \
    website_uri:string
