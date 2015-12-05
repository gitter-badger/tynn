class Tynn
  # The following methods are inherited by Syro:

  # Public: Executes the given block if the request method is +GET+.
  #
  # Examples
  #
  #   get do
  #     render("posts", posts: Post.all)
  #   end
  #
  # Signature
  #
  #   get(&block)
  #
  # Inherited by Syro::Deck::API.

  # Public: Executes the given block if the request method is +POST+.
  #
  # Examples
  #
  #   post do
  #     user = User.create(req[:user])
  #
  #     res.status = 201
  #   end
  #
  # Signature
  #
  #   post(&block)
  #
  # Inherited by Syro::Deck::API.

  # Public: Executes the given block if the request method is +PATCH+.
  #
  # Examples
  #
  #   patch do
  #     user.update(req[:user])
  #
  #     res.write(user.to_json)
  #   end
  #
  # Signature
  #
  #   patch(&block)
  #
  # Inherited by Syro::Deck::API.

  # Public: Executes the given block if the request method is +PUT+.
  #
  # Examples
  #
  #   put do
  #     user.update(req[:user])
  #
  #     res.write(user.to_json)
  #   end
  #
  # Signature
  #
  #   put(&block)
  #
  # Inherited by Syro::Deck::API.

  # Public: Executes the given block if the request method is +DELETE+.
  #
  # Examples
  #
  #   delete do
  #     user.delete
  #
  #     res.status = 204
  #   end
  #
  # Signature
  #
  #   delete(&block)
  #
  # Inherited by Syro::Deck::API.

  # Public: Immediately stops the request and returns +response+
  # as per Rack's specification.
  #
  # response - An Array of three elements: status, headers and body.
  #
  # Examples
  #
  #   halt([200, { "Content-Type" => "text/html" }, ["hello"]])
  #   halt([res.status, res.headers, res.body])
  #   halt(res.finish)
  #
  # Signature
  #
  #   halt(response)
  #
  # Inherited by Syro::Response.

  # Public: Returns the incoming request object. This object is an
  # instance of Tynn::Request.
  #
  # Examples
  #
  #   req.post?      # => true
  #   req.params     # => { "username" => "bob", "password" => "secret" }
  #   req[:username] # => "bob"
  #
  # Signature
  #
  #   req()
  #
  # Inherited by Syro::Response.

  # Public: Returns the current response object. This object is an instance
  # of Tynn::Response.
  #
  # Examples
  #
  #   res.status = 200
  #   res["Content-Type"] = "text/html"
  #   res.write("<h1>Welcome back!</h1>")
  #
  # Signature
  #
  #   res()
  #
  # Inherited by Syro::Response.
end
