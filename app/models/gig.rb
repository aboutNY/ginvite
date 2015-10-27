class Gig < ActiveRecord::Base
  def self.search(search) #self.でクラスメソッドとしている
    if search # Controllerから渡されたパラメータが!= nilの場合は、titleカラムを部分一致検索
      Gig.where(['artist LIKE ?', "%#{search}%"])
    else
      Gig.all #全て表示。
    end
  end
end
