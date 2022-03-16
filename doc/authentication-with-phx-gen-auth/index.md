# Authentication with phx.gen.auth

See:

* https://github.com/aaronrenner/phx_gen_auth

* https://experimentingwithcode.com/phoenix-authentication-with-phx-gen-auth-part-1/

* https://experimentingwithcode.com/phoenix-authentication-with-phx-gen-auth-part-2/

* https://fullstackphoenix.com/tutorials/combining-authentication-solutions-with-guardian-and-phx-gen-auth


## Testing controllers

To test a controller that need authenticated routes, edit the file `./test/example_controller_test.exs`, and add a `setup` step:

```ex
setup :register_and_log_in_user
```
