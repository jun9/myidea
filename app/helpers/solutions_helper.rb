module SolutionsHelper
  def new_solution_button(idea)
    if can? :create,Solution
      content_tag :div,:class=>"btn-group" do
        button_tag I18n.t("app.solution.new"),:class=>"solution-btn btn btn-primary","data-idea"=> idea.id
      end
    end
  end
end
