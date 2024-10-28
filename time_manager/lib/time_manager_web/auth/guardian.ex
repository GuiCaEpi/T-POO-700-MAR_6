defmodule TodolistWeb.Auth.Guardian do
  use Guardian, otp_app: :time_manager

  alias Todolist.Accounts
  alias TodolistWeb.Utils

  # ========================
  #    TOKEN FUNCTIONS
  # ========================

  # Crée un sujet pour le token basé sur l'ID de l'utilisateur
  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)                                                  # Convertit l'ID en chaîne
    {:ok, sub}                                                           # Retourne l'ID sous forme de sujet pour le token
  end

  # Gère le cas où aucun ID n'est fourni pour créer un sujet de token
  def subject_for_token(_, _) do
    {:error, :no_id_provided}                                            # Erreur lorsque l'ID n'est pas fourni
  end

  # ========================
  #  RESOURCE FUNCTIONS
  # ========================

  # Récupère une ressource basée sur les revendications (claims) du token
  def resource_from_claims(%{"sub" => id, "c-xsrf-token" => csrf_token}) do
    case Accounts.get_user!(id) do
      nil -> {:error, :resource_not_found}                               # Erreur si la ressource n'est pas trouvée
      resource -> {:ok, {resource, csrf_token}}                          # Retourne la ressource et le token CSRF associé
    end
  end

  # Gère le cas où aucun ID n'est fourni dans les revendications
  def resource_from_claims(_claims) do
    {:error, :no_id_provided}                                            # Erreur si l'ID n'est pas fourni dans les claims
  end

  # ========================
  # AUTHENTICATION FUNCTIONS
  # ========================

  # Authentifie un utilisateur en fonction de l'email et du mot de passe
  def authenticate(email, password) do
    case Accounts.get_user_by_email(email) do
      nil -> {:error, :unauthorized}                                     # Erreur si l'utilisateur n'est pas trouvé
      user ->
        case validate_password(password, user.password_hash) do
          true ->
            case create_token(user) do
              {:ok, user, token, csrf_token} -> {:ok, user, token, csrf_token} # Retourne les infos d'utilisateur et tokens
              {:error, reason} -> {:error, reason}                      # Erreur si la création du token échoue
            end
          false -> {:error, :unauthorized}                               # Erreur si la validation du mot de passe échoue
        end
     end
  end

  # ========================
  # HELPER FUNCTIONS
  # ========================

  # Valide le mot de passe en le comparant avec le hash stocké
  defp validate_password(password, password_hash) do
    Bcrypt.verify_pass(password, password_hash)                          # Vérifie le mot de passe avec Bcrypt
  end

  # Crée un token avec les informations utilisateur et génère un token CSRF
  defp create_token(user) do
    csrf_token = TodolistWeb.Utils.generate_csrf_token()                 # Génère un token CSRF
    exp = DateTime.to_unix(DateTime.utc_now() |> DateTime.add(30 * 24 * 60 * 60)) # Expiration dans 30 jours

    claims = %{
      "c-xsrf-token" => csrf_token,                                      # Inclut le token CSRF dans les claims
      "sub" => to_string(user.id),                                       # ID de l'utilisateur
      "privilege_level" => user.privilege_level,                         # Niveau de privilège de l'utilisateur
      "exp" => exp                                                       # Date d'expiration du token
    }

    {:ok, token, _claims} = encode_and_sign(user, claims)                # Encode et signe le token avec les claims

    {:ok, user, token, csrf_token}                                       # Retourne l'utilisateur, le token et le token CSRF
  end

  # ========================
  # CSRF VALIDATION
  # ========================

  # Valide le token CSRF en comparant celui de la requête avec celui des claims
  def validate_csrf_token(csrf_token_from_request, csrf_token_from_claims) do
    csrf_token_from_request == csrf_token_from_claims                    # Retourne true si les tokens CSRF correspondent
  end
end
