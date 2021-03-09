class WinesController < ApplicationController
    def index

        @wines = Wine.all
        @wine = Wine.new
        @strains = Strain.all

    end
    
    def create
      
      @wine = Wine.new(wine_params)
      
      strain_ids = params[:wine][:strain_ids]
      strain_ids.delete("")

      strain_percents = params[:wine][:strain_percent]
      strain_percents.delete("")

      begin
        
        Wine.transaction do
          
          @wine.save
  
          strain_ids.length.times do |i|
  
            WineStrain.create(
              wine_id: @wine.id,
              strain_id: strain_ids[i],
              percent: strain_percents[i]
            )
  
          end
  
          flash[:success] = "Wine successfully created"
          redirect_to root_path
  
        end
      rescue

        flash[:error] = "Something went wrong"
        redirect_to root_path

      end

    end
    
    private
    def wine_params
        params.require(:wine).permit(:name)
    end
end