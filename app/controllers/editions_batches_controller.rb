class EditionsBatchesController < ApplicationController
  def update
    editions = Edition.where(id: params.fetch(:edition_ids))
    update_editions_count = editions.update_all(build_edition_params)
    render json: update_editions_count
  end

  private

  def build_edition_params
    edition_params = batch_params.slice(:read)
    if batch_params[:category]
      edition_params[:edition_category_id] = EditionCategory.find_by(code: batch_params[:category][:code]).try(:id)
    end
    if batch_params[:publisher]
      edition_params[:publisher_id] = Publisher.find_by(name: batch_params[:publisher][:name]).try(:id)
    end
    edition_params.compact
  end

  def batch_params
    @batch_params ||= params.require(:editions_batch).permit(:read, category: [:code], publisher: [:name])
  end
end