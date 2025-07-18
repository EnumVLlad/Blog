class BlogSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :body, :category, :user_id, :created_at, :updated_at
end
