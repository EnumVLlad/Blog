class CommentPolicy
  attr_reader :user, :comment

  def initialize(user, comment)
    @user = user
    @comment = comment
  end

  def destroy?
    user.present? && (comment.user == user || user.admin?)
  end
end
