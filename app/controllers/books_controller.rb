class BooksController < ApplicationController

  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update]

  def index
    @books = Book.all.order(created_at: :desc)
    @user = current_user
    @book_new = Book.new
  end

  def show
    @book = Book.find(params[:id])
    @user = current_user
    @book_new = Book.new
  end

  def create
    @book_new = Book.new(book_params)
    @book_new.user_id = current_user.id
    if @book_new.save
      redirect_to book_path(@book_new), notice: 'You have created book successfully'
    else
      @books = Book.all.order(created_at: :desc)
      @user = current_user
      render :index
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def correct_user
    book = Book.find(params[:id])
    if current_user.id != book.user.id
      redirect_to books_path
    end
  end

  def book_params
    params.require(:book).permit(:title, :body, :user_id)
  end

end
