module Api
  module V1
    class BlogsController < ApplicationController
      def index
        blogs = Blog.all
        render json: BlogSerializer.new(blogs).serializable_hash.to_json
      end

      def show
        blog = Blog.find(params[:id])
        render json: BlogSerializer.new(blog).serializable_hash.to_json
      end

      def create
        blog = Blog.new(blog_params)
        if blog.save
          render json: BlogSerializer.new(blog).serializable_hash.to_json, status: :created
        else
          render json: { errors: blog.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        blog = Blog.find(params[:id])
        if blog.update(blog_params)
          render json: BlogSerializer.new(blog).serializable_hash.to_json
        else
          render json: { errors: blog.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        blog = Blog.find(params[:id])
        blog.destroy
        head :no_content
      end

      private

      def blog_params
        params.require(:blog).permit(:title, :body, :category, :user_id)
      end
    end
  end
end
