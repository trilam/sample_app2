class User < ActiveRecord::Base
    has_many :microposts, dependent: :destroy
	attr_accessor :remember_token, :activation_token, :reset_token
	before_save :downcase_email
    before_create :create_activation_digest
	validates :name, presence: true, length: {maximum: 50}
	VALID_EMAIL_REGEX= /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: {maximum: 255},
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false}
	has_secure_password
    # allow_blank is for editing the users without providing password.
    # has_secure_password above will stop blank password to be created.
	validates :password, length: {minimum: 6}, allow_blank: true

	# Returns the hash digest of a string - minimum cost -
	def User.digest(string)
      BCrypt::Password.create(string, cost:BCrypt::Engine::MIN_COST)
 	end

    # Returns a random token
    def User.new_token
     SecureRandom.urlsafe_base64
    end

    def remember
     self.remember_token = User.new_token
     update_attribute(:remember_digest, User.digest(remember_token))
    end

    def authenticated?(attribute,token)
      digest = self.send("#{attribute}_digest")
      return false if digest.nil?
      BCrypt::Password.new(digest).is_password?(token)
    end

	def forget
      update_attribute(:remember_digest, nil)
	end

    def activate
      self.update_attribute(:activated, true)
      self.update_attribute(:activated_at, Time.zone.now)
    end 

    def send_activation_email
      UserMailer.account_activation(self).deliver_now
    end

    def create_reset_digest
      self.reset_token = User.new_token
      update_attribute(:reset_digest, User.digest(reset_token))
      update_attribute(:reset_sent_at, Time.zone.now)
    end
   
    def send_password_reset_email
      UserMailer.password_reset(self).deliver_now
    end

    def password_reset_expired?
      reset_sent_at < 2.hours.ago
    end

    def feed
      Micropost.where("user_id = ?", id)
    end
   
    private

      def downcase_email
        self.email = email.downcase
      end

      def create_activation_digest
        self.activation_token  = User.new_token
        self.activation_digest = User.digest(activation_token)
      end
         
end
