class CommentsController < ApplicationController
    before_action :find_movie
    before_action :find_comment, only: [:destroy, :edit, :update, :comment_user]
    before_action :comment_user, only: [:destroy, :edit, :update]
    before_action :comment_limit, only: [:create]

    
    def create
        @comment = @movie.comment.create(params[:content].permit(:content))
        @comment.user_id = current_user.id
        @comment.save
        
        if @comment.save
            redirect_to movie_path(@movie)
        else
            render 'new'
        end
    end
    
    def destroy
       @comment.destroy
       redirect_to movie_path(@movie)
    end
    
    def edit
        
    end
    
    def update
        if @comment.update(params[:comment].permit(:content))
            redirect_to movie_path(@movie)
        else
            render 'edit'
        end
    end
    
    private
    
    def find_movie
        @movie = Movie.find(params[:id])
    end
    
    def find_comment
       @comment = @movie.comment.find(params[:id]) 
    end
    
    def comment_user
       unless current_user.id == @comment.user_id
            flash[:notice] = "It's not your comment."
            redirect_to @movie
       end
    end
    
    def comment_limit
       user_commented = current_user.movie_comment(@movie)
       
       if user_commented.present
            flash[:notice] = "You have already commented on that movie."
            redirect_to edit_movie_comment_path(@movie, user_comment)
       end
    end
end
