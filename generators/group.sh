mix phx.gen.html --binary-id \
  Groups Group groups \
    type_id:string \
    state_id:string \
    user_id:references:users \
    handle:unique \
    verified:boolean \
    email:unique \
    phone:unique \
    street:string \
    premise:string \
    locality:string \
    province:string \
    postcode:string \
    country:string \
    title:string \
    subtitle:string \
    summary:text \
    saga:text \
    image_uri:string \
    website_uri:string \
    facebook_uri:string \
    instagram_uri:string \
    linkedin_uri:string \
    medium_uri:string \
    pinterest_uri:string \
    soundcloud_uri:string \
    tiktok_uri:string \
    twitter_uri:string \
    wikipedia_uri:string \
    youtube_uri:string \
    removed_at:utc_datetime_usec
