require_relative "../lib/tynn"

class Users < Tynn
end

Users.define do
  get do
    res.write("GET /users")
  end

  post do
    res.write("POST /users")
  end

  on(:id) do |id|
    get do
      res.write("GET /users/#{ id }")
    end

    put do
      res.write("PUT /users/#{ id }")
    end

    patch do
      res.write("PATCH /users/#{ id }")
    end

    delete do
      res.write("DELETE /users/#{ id }")
    end
  end
end

Tynn.define do
  on("users") do
    run(Users)
  end
end

run(Tynn)
