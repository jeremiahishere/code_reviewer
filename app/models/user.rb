class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :project_members
  has_many :projects, :through => :project_members

  has_many :reviews, :foreign_key => :submitter_id

  has_many :assignments
  has_many :roles, :through => :assignments

  # formtastic can't save without this
  # probably because I am using assignmenst instaed of role_users
  attr_accessible :role_ids

  def name
    self.email
  end

  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

  default_scope :order => :email

  def self.coders
    User.all.select { |u| u.has_role?(:coder) }
  end

  def self.managers
    User.all.select { |u| u.has_role?(:manager) }
  end

  # This returns reviews that the user needs to take action on
  # Either the vote is no opinion or the review needs to be closed
  #
  # @return [Array] An array of reviews that the user needs to vote on or close
  def pending_reviews
    pending_reviews = []
    self.projects.each do |p|
      p.reviews.each do |r|
        if !r.closed?
          if r.approved? && r.submitter == self 
            pending_reviews.push(r)
          elsif r.review_votes.select{ |v| v.vote == ReviewVote.allowable_votes[:no_opinion] && v.user == self }
            pending_reviews.push(r)
          end
        end
      end
    end
    return pending_reviews
  end
end
