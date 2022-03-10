class Api::V1::UsersController < ApplicationController
    def show
        render json: User.find(params[:id])
    end

    # create user
    def create
        user = User.new user_params
        if user.save
            render json: user, status: 201, location: [:api_v1, user]
        else
            render json: { errors: user.errors }, status: 422
        end
    end

    # update user
    def update
        user = User.find(params[:id])

        if user.update(user_params)
            render json: user, status: 200, location: [:api_v1, user]
        else
            render json: { errors: user.errors }, status: 422
        end
    end

    # delete user
    def destroy
        user = User.find(params[:id])
        user.destroy
        head 204
    end

    private

    def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
    end
end