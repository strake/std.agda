------------------------------------------------------------------------
-- Sums of binary relations
------------------------------------------------------------------------

module Relation.Binary.Sum where

open import Logic
open import Data.Function
open import Data.Sum
open import Data.Product
open import Data.Unit
open import Relation.Nullary
open import Relation.Binary
open import Relation.Binary.PropositionalEquality

infixr 1 _⊎-Rel_ _⊎-<_

------------------------------------------------------------------------
-- Sums of relations

-- Generalised sum.

data ⊎ʳ (P : Set) {a₁ : Set} (_∼₁_ : Rel a₁)
                  {a₂ : Set} (_∼₂_ : Rel a₂)
          : a₁ ⊎ a₂ -> a₁ ⊎ a₂ -> Set where
  ₁∼₂ : forall {x y} -> P      -> ⊎ʳ P _∼₁_ _∼₂_ (inj₁ x) (inj₂ y)
  ₁∼₁ : forall {x y} -> x ∼₁ y -> ⊎ʳ P _∼₁_ _∼₂_ (inj₁ x) (inj₁ y)
  ₂∼₂ : forall {x y} -> x ∼₂ y -> ⊎ʳ P _∼₁_ _∼₂_ (inj₂ x) (inj₂ y)

-- Pointwise sum.

_⊎-Rel_ : forall {a₁} (_∼₁_ : Rel a₁) ->
          forall {a₂} (_∼₂_ : Rel a₂) ->
          Rel (a₁ ⊎ a₂)
_⊎-Rel_ = ⊎ʳ ⊥

-- All things to the left are smaller than (or equal to, depending on
-- the underlying equality) all things to the right.

_⊎-<_ : forall {a₁} (_∼₁_ : Rel a₁) ->
        forall {a₂} (_∼₂_ : Rel a₂) ->
        Rel (a₁ ⊎ a₂)
_⊎-<_ = ⊎ʳ ⊤

------------------------------------------------------------------------
-- Helpers

private

  ₂≁₁ :  forall {a₁} -> {∼₁ : Rel a₁}
      -> forall {a₂} -> {∼₂ : Rel a₂}
      -> forall {P x y} -> ¬ (inj₂ x ⟨ ⊎ʳ P ∼₁ ∼₂ ⟩₁ inj₁ y)
  ₂≁₁ ()

  ₁≁₂ :  forall {a₁} -> {∼₁ : Rel a₁}
      -> forall {a₂} -> {∼₂ : Rel a₂}
      -> forall {x y} -> ¬ (inj₁ x ⟨ ∼₁ ⊎-Rel ∼₂ ⟩₁ inj₂ y)
  ₁≁₂ (₁∼₂ ())

  drop-inj₁ :  forall {a₁} -> {∼₁ : Rel a₁}
            -> forall {a₂} -> {∼₂ : Rel a₂}
            -> forall {P x y}
            -> inj₁ x ⟨ ⊎ʳ P ∼₁ ∼₂ ⟩₁ inj₁ y -> ∼₁ x y
  drop-inj₁ (₁∼₁ x∼y) = x∼y

  drop-inj₂ :  forall {a₁} -> {∼₁ : Rel a₁}
            -> forall {a₂} -> {∼₂ : Rel a₂}
            -> forall {P x y}
            -> inj₂ x ⟨ ⊎ʳ P ∼₁ ∼₂ ⟩₁ inj₂ y -> ∼₂ x y
  drop-inj₂ (₂∼₂ x∼y) = x∼y

  ₂≰₁ :  forall {a₁} -> {≤₁ : Rel a₁}
      -> forall {a₂} -> {≤₂ : Rel a₂}
      -> forall {x y} -> ¬ (inj₂ x ⟨ ≤₁ ⊎-< ≤₂ ⟩₁ inj₁ y)
  ₂≰₁ ()

------------------------------------------------------------------------
-- Some properties which are preserved by the relation formers above

_⊎-reflexive_
  :  forall {a₁} -> {≈₁ ∼₁ : Rel a₁} -> ≈₁ ⇒ ∼₁
  -> forall {a₂} -> {≈₂ ∼₂ : Rel a₂} -> ≈₂ ⇒ ∼₂
  -> forall {P} -> (≈₁ ⊎-Rel ≈₂) ⇒ (⊎ʳ P ∼₁ ∼₂)
refl₁ ⊎-reflexive refl₂ = refl
  where
  refl : (_ ⊎-Rel _) ⇒ (⊎ʳ _ _ _)
  refl (₁∼₁ x₁≈y₁) = ₁∼₁ (refl₁ x₁≈y₁)
  refl (₂∼₂ x₂≈y₂) = ₂∼₂ (refl₂ x₂≈y₂)
  refl (₁∼₂ ())

_⊎-refl_
  :  forall {a₁} -> {∼₁ : Rel a₁} -> Reflexive ∼₁
  -> forall {a₂} -> {∼₂ : Rel a₂} -> Reflexive ∼₂
  -> Reflexive (∼₁ ⊎-Rel ∼₂)
refl₁ ⊎-refl refl₂ = refl
  where
  refl : Reflexive (_ ⊎-Rel _)
  refl {x = inj₁ _} = ₁∼₁ refl₁
  refl {x = inj₂ _} = ₂∼₂ refl₂

_⊎-irreflexive_
  :  forall {a₁} -> {≈₁ <₁ : Rel a₁} -> Irreflexive ≈₁ <₁
  -> forall {a₂} -> {≈₂ <₂ : Rel a₂} -> Irreflexive ≈₂ <₂
  -> forall {P} -> Irreflexive (≈₁ ⊎-Rel ≈₂) (⊎ʳ P <₁ <₂)
irrefl₁ ⊎-irreflexive irrefl₂ = irrefl
  where
  irrefl : Irreflexive (_ ⊎-Rel _) (⊎ʳ _ _ _)
  irrefl (₁∼₁ x₁≈y₁) (₁∼₁ x₁<y₁) = irrefl₁ x₁≈y₁ x₁<y₁
  irrefl (₂∼₂ x₂≈y₂) (₂∼₂ x₂<y₂) = irrefl₂ x₂≈y₂ x₂<y₂
  irrefl (₁∼₂ ())    _

_⊎-symmetric_
  :  forall {a₁} -> {∼₁ : Rel a₁} -> Symmetric ∼₁
  -> forall {a₂} -> {∼₂ : Rel a₂} -> Symmetric ∼₂
  -> Symmetric (∼₁ ⊎-Rel ∼₂)
sym₁ ⊎-symmetric sym₂ = sym
  where
  sym : Symmetric (_ ⊎-Rel _)
  sym (₁∼₁ x₁∼y₁) = ₁∼₁ (sym₁ x₁∼y₁)
  sym (₂∼₂ x₂∼y₂) = ₂∼₂ (sym₂ x₂∼y₂)
  sym (₁∼₂ ())

_⊎-transitive_
  :  forall {a₁} -> {∼₁ : Rel a₁} -> Transitive ∼₁
  -> forall {a₂} -> {∼₂ : Rel a₂} -> Transitive ∼₂
  -> forall {P} -> Transitive (⊎ʳ P ∼₁ ∼₂)
trans₁ ⊎-transitive trans₂ = trans
  where
  trans : Transitive (⊎ʳ _ _ _)
  trans (₁∼₁ x∼y) (₁∼₁ y∼z) = ₁∼₁ (trans₁ x∼y y∼z)
  trans (₂∼₂ x∼y) (₂∼₂ y∼z) = ₂∼₂ (trans₂ x∼y y∼z)
  trans (₁∼₂ p)   (₂∼₂ _)     = ₁∼₂ p
  trans (₁∼₁ _)   (₁∼₂ p)     = ₁∼₂ p

_⊎-antisymmetric_
  :  forall {a₁} -> {≈₁ ≤₁ : Rel a₁} -> Antisymmetric ≈₁ ≤₁
  -> forall {a₂} -> {≈₂ ≤₂ : Rel a₂} -> Antisymmetric ≈₂ ≤₂
  -> forall {P} -> Antisymmetric (≈₁ ⊎-Rel ≈₂) (⊎ʳ P ≤₁ ≤₂)
antisym₁ ⊎-antisymmetric antisym₂ = antisym
  where
  antisym : Antisymmetric (_ ⊎-Rel _) (⊎ʳ _ _ _)
  antisym (₁∼₁ x≤y) (₁∼₁ y≤x) = ₁∼₁ (antisym₁ x≤y y≤x)
  antisym (₂∼₂ x≤y) (₂∼₂ y≤x) = ₂∼₂ (antisym₂ x≤y y≤x)
  antisym (₁∼₂ _)   ()

_⊎-asymmetric_
  :  forall {a₁} -> {<₁ : Rel a₁} -> Asymmetric <₁
  -> forall {a₂} -> {<₂ : Rel a₂} -> Asymmetric <₂
  -> forall {P} -> Asymmetric (⊎ʳ P <₁ <₂)
asym₁ ⊎-asymmetric asym₂ = asym
  where
  asym : Asymmetric (⊎ʳ _ _ _)
  asym (₁∼₁ x<y) (₁∼₁ y<x) = asym₁ x<y y<x
  asym (₂∼₂ x<y) (₂∼₂ y<x) = asym₂ x<y y<x
  asym (₁∼₂ _)   ()

_⊎-≈-respects₂_
  :  forall {a₁} -> {≈₁ ∼₁ : Rel a₁}
  -> ≈₁ Respects₂ ∼₁
  -> forall {a₂} -> {≈₂ ∼₂ : Rel a₂}
  -> ≈₂ Respects₂ ∼₂
  -> forall {P} -> (≈₁ ⊎-Rel ≈₂) Respects₂ (⊎ʳ P ∼₁ ∼₂)
_⊎-≈-respects₂_ {≈₁ = ≈₁} {∼₁ = ∼₁} resp₁
                {≈₂ = ≈₂} {∼₂ = ∼₂} resp₂ {P} =
  (\{_ _ _} -> resp¹) ,
  (\{_ _ _} -> resp²)
  where
  resp¹ : forall {x} -> (≈₁ ⊎-Rel ≈₂) Respects ((⊎ʳ P ∼₁ ∼₂) x)
  resp¹ (₁∼₁ y≈y') (₁∼₁ x∼y) = ₁∼₁ (proj₁ resp₁ y≈y' x∼y)
  resp¹ (₂∼₂ y≈y') (₂∼₂ x∼y) = ₂∼₂ (proj₁ resp₂ y≈y' x∼y)
  resp¹ (₂∼₂ y≈y') (₁∼₂ p)   = (₁∼₂ p)
  resp¹ (₁∼₂ ())   _

  resp² :  forall {y}
        -> (≈₁ ⊎-Rel ≈₂) Respects (flip₁ (⊎ʳ P ∼₁ ∼₂) y)
  resp² (₁∼₁ x≈x') (₁∼₁ x∼y) = ₁∼₁ (proj₂ resp₁ x≈x' x∼y)
  resp² (₂∼₂ x≈x') (₂∼₂ x∼y) = ₂∼₂ (proj₂ resp₂ x≈x' x∼y)
  resp² (₁∼₁ x≈x') (₁∼₂ p)   = (₁∼₂ p)
  resp² (₁∼₂ ())   _

_⊎-substitutive_
  :  forall {a₁} -> {∼₁ : Rel a₁} -> Substitutive ∼₁
  -> forall {a₂} -> {∼₂ : Rel a₂} -> Substitutive ∼₂
  -> Substitutive (∼₁ ⊎-Rel ∼₂)
subst₁ ⊎-substitutive subst₂ = subst
  where
  subst : Substitutive (_ ⊎-Rel _)
  subst P (₁∼₁ x∼y) Px = subst₁ (\z -> P (inj₁ z)) x∼y Px
  subst P (₂∼₂ x∼y) Px = subst₂ (\z -> P (inj₂ z)) x∼y Px
  subst P (₁∼₂ ())  Px

⊎-decidable
  :  forall {a₁} -> {∼₁ : Rel a₁} -> Decidable ∼₁
  -> forall {a₂} -> {∼₂ : Rel a₂} -> Decidable ∼₂
  -> forall {P}
  -> (forall {x y} -> Dec (inj₁ x ⟨ ⊎ʳ P ∼₁ ∼₂ ⟩₁ inj₂ y))
  -> Decidable (⊎ʳ P ∼₁ ∼₂)
⊎-decidable {∼₁ = ∼₁} dec₁ {∼₂ = ∼₂} dec₂ {P} dec₁₂ = dec
  where
  dec : Decidable (⊎ʳ P ∼₁ ∼₂)
  dec (inj₁ x) (inj₁ y) with dec₁ x y
  ...                   | yes x∼y = yes (₁∼₁ x∼y)
  ...                   | no  x≁y = no (x≁y ∘ drop-inj₁)
  dec (inj₂ x) (inj₂ y) with dec₂ x y
  ...                   | yes x∼y = yes (₂∼₂ x∼y)
  ...                   | no  x≁y = no (x≁y ∘ drop-inj₂)
  dec (inj₁ x) (inj₂ y) = dec₁₂
  dec (inj₂ x) (inj₁ y) = no ₂≁₁

_⊎-<-total_
  :  forall {a₁} -> {≤₁ : Rel a₁} -> Total ≤₁
  -> forall {a₂} -> {≤₂ : Rel a₂} -> Total ≤₂
  -> Total (≤₁ ⊎-< ≤₂)
total₁ ⊎-<-total total₂ = total
  where
  total : Total (_ ⊎-< _)
  total (inj₁ x) (inj₁ y) = map-⊎ ₁∼₁ ₁∼₁ $ total₁ x y
  total (inj₂ x) (inj₂ y) = map-⊎ ₂∼₂ ₂∼₂ $ total₂ x y
  total (inj₁ x) (inj₂ y) = inj₁ (₁∼₂ _)
  total (inj₂ x) (inj₁ y) = inj₂ (₁∼₂ _)

_⊎-<-trichotomous_
  :  forall {a₁} -> {≈₁ <₁ : Rel a₁} -> Trichotomous ≈₁ <₁
  -> forall {a₂} -> {≈₂ <₂ : Rel a₂} -> Trichotomous ≈₂ <₂
  -> Trichotomous (≈₁ ⊎-Rel ≈₂) (<₁ ⊎-< <₂)
_⊎-<-trichotomous_ {≈₁ = ≈₁} {<₁ = <₁} tri₁
                   {≈₂ = ≈₂} {<₂ = <₂} tri₂ = tri
  where
  tri : Trichotomous (≈₁ ⊎-Rel ≈₂) (<₁ ⊎-< <₂)
  tri (inj₁ x) (inj₂ y) = Tri₁ (₁∼₂ _) ₁≁₂ ₂≁₁
  tri (inj₂ x) (inj₁ y) = Tri₃ ₂≁₁ ₂≁₁ (₁∼₂ _)
  tri (inj₁ x) (inj₁ y) with tri₁ x y
  ...                   | Tri₁ x<y x≉y x≯y =
    Tri₁ (₁∼₁ x<y)        (x≉y ∘ drop-inj₁) (x≯y ∘ drop-inj₁)
  ...                   | Tri₂ x≮y x≈y x≯y =
    Tri₂ (x≮y ∘ drop-inj₁) (₁∼₁ x≈y)    (x≯y ∘ drop-inj₁)
  ...                   | Tri₃ x≮y x≉y x>y =
    Tri₃ (x≮y ∘ drop-inj₁) (x≉y ∘ drop-inj₁) (₁∼₁ x>y)
  tri (inj₂ x) (inj₂ y) with tri₂ x y
  ...                   | Tri₁ x<y x≉y x≯y =
    Tri₁ (₂∼₂ x<y)        (x≉y ∘ drop-inj₂) (x≯y ∘ drop-inj₂)
  ...                   | Tri₂ x≮y x≈y x≯y =
    Tri₂ (x≮y ∘ drop-inj₂) (₂∼₂ x≈y)    (x≯y ∘ drop-inj₂)
  ...                   | Tri₃ x≮y x≉y x>y =
    Tri₃ (x≮y ∘ drop-inj₂) (x≉y ∘ drop-inj₂) (₂∼₂ x>y)

------------------------------------------------------------------------
-- Some collections of properties which are preserved

_⊎-isEquivalence_
  :  forall {a₁} -> {≈₁ : Rel a₁} -> IsEquivalence ≈₁
  -> forall {a₂} -> {≈₂ : Rel a₂} -> IsEquivalence ≈₂
  -> IsEquivalence (≈₁ ⊎-Rel ≈₂)
eq₁ ⊎-isEquivalence eq₂ = record
  { refl  = refl  eq₁ ⊎-refl        refl  eq₂
  ; sym   = sym   eq₁ ⊎-symmetric   sym   eq₂
  ; trans = trans eq₁ ⊎-transitive  trans eq₂
  }
  where open IsEquivalence

_⊎-isPreorder_
  :  forall {a₁} -> {≈₁ ∼₁ : Rel a₁} -> IsPreorder ≈₁ ∼₁
  -> forall {a₂} -> {≈₂ ∼₂ : Rel a₂} -> IsPreorder ≈₂ ∼₂
  -> forall {P} -> IsPreorder (≈₁ ⊎-Rel ≈₂) (⊎ʳ P ∼₁ ∼₂)
pre₁ ⊎-isPreorder pre₂ = record
  { isEquivalence = isEquivalence pre₁ ⊎-isEquivalence
                    isEquivalence pre₂
  ; reflexive     = reflexive pre₁ ⊎-reflexive   reflexive pre₂
  ; trans         = trans     pre₁ ⊎-transitive  trans     pre₂
  ; ≈-resp-∼      = ≈-resp-∼  pre₁ ⊎-≈-respects₂ ≈-resp-∼  pre₂
  }
  where open IsPreorder

_⊎-isDecEquivalence_
  :  forall {a₁} -> {≈₁ : Rel a₁} -> IsDecEquivalence ≈₁
  -> forall {a₂} -> {≈₂ : Rel a₂} -> IsDecEquivalence ≈₂
  -> IsDecEquivalence (≈₁ ⊎-Rel ≈₂)
eq₁ ⊎-isDecEquivalence eq₂ = record
  { isEquivalence = isEquivalence eq₁ ⊎-isEquivalence
                    isEquivalence eq₂
  ; _≟_           = ⊎-decidable (_≟_ eq₁) (_≟_ eq₂) (no ₁≁₂)
  }
  where open IsDecEquivalence

_⊎-isPartialOrder_
  :  forall {a₁} -> {≈₁ ≤₁ : Rel a₁} -> IsPartialOrder ≈₁ ≤₁
  -> forall {a₂} -> {≈₂ ≤₂ : Rel a₂} -> IsPartialOrder ≈₂ ≤₂
  -> forall {P} -> IsPartialOrder (≈₁ ⊎-Rel ≈₂) (⊎ʳ P ≤₁ ≤₂)
po₁ ⊎-isPartialOrder po₂ = record
  { isPreorder = isPreorder po₁ ⊎-isPreorder    isPreorder po₂
  ; antisym    = antisym    po₁ ⊎-antisymmetric antisym    po₂
  }
  where open IsPartialOrder

_⊎-isStrictPartialOrder_
  :  forall {a₁} -> {≈₁ <₁ : Rel a₁} -> IsStrictPartialOrder ≈₁ <₁
  -> forall {a₂} -> {≈₂ <₂ : Rel a₂} -> IsStrictPartialOrder ≈₂ <₂
  -> forall {P} -> IsStrictPartialOrder (≈₁ ⊎-Rel ≈₂) (⊎ʳ P <₁ <₂)
spo₁ ⊎-isStrictPartialOrder spo₂ = record
  { isEquivalence = isEquivalence spo₁ ⊎-isEquivalence
                    isEquivalence spo₂
  ; irrefl        = irrefl   spo₁ ⊎-irreflexive irrefl   spo₂
  ; trans         = trans    spo₁ ⊎-transitive  trans    spo₂
  ; ≈-resp-<      = ≈-resp-< spo₁ ⊎-≈-respects₂ ≈-resp-< spo₂
  }
  where open IsStrictPartialOrder

_⊎-<-isTotalOrder_
  :  forall {a₁} -> {≈₁ ≤₁ : Rel a₁} -> IsTotalOrder ≈₁ ≤₁
  -> forall {a₂} -> {≈₂ ≤₂ : Rel a₂} -> IsTotalOrder ≈₂ ≤₂
  -> IsTotalOrder (≈₁ ⊎-Rel ≈₂) (≤₁ ⊎-< ≤₂)
to₁ ⊎-<-isTotalOrder to₂ = record
  { isPartialOrder = isPartialOrder to₁ ⊎-isPartialOrder
                     isPartialOrder to₂
  ; total          = total to₁ ⊎-<-total total to₂
  }
  where open IsTotalOrder

_⊎-<-isDecTotalOrder_
  :  forall {a₁} -> {≈₁ ≤₁ : Rel a₁} -> IsDecTotalOrder ≈₁ ≤₁
  -> forall {a₂} -> {≈₂ ≤₂ : Rel a₂} -> IsDecTotalOrder ≈₂ ≤₂
  -> IsDecTotalOrder (≈₁ ⊎-Rel ≈₂) (≤₁ ⊎-< ≤₂)
to₁ ⊎-<-isDecTotalOrder to₂ = record
  { isTotalOrder = isTotalOrder to₁ ⊎-<-isTotalOrder isTotalOrder to₂
  ; _≟_          = ⊎-decidable (_≟_  to₁) (_≟_  to₂) (no ₁≁₂)
  ; _≤?_         = ⊎-decidable (_≤?_ to₁) (_≤?_ to₂) (yes (₁∼₂ _))
  }
  where open IsDecTotalOrder

------------------------------------------------------------------------
-- The game can be taken even further...

_⊎-setoid_ : Setoid -> Setoid -> Setoid
s₁ ⊎-setoid s₂ = record
  { carrier       = carrier       s₁ ⊎               carrier       s₂
  ; _≈_           = _≈_           s₁ ⊎-Rel           _≈_           s₂
  ; isEquivalence = isEquivalence s₁ ⊎-isEquivalence isEquivalence s₂
  }
  where open Setoid

_⊎-preorder_ : Preorder -> Preorder -> Preorder
p₁ ⊎-preorder p₂ = record
  { carrier      = carrier      p₁ ⊎            carrier      p₂
  ; _≈_          = _≈_          p₁ ⊎-Rel        _≈_          p₂
  ; _∼_          = _∼_          p₁ ⊎-Rel        _∼_          p₂
  ; isPreorder   = isPreorder   p₁ ⊎-isPreorder isPreorder   p₂
  }
  where open Preorder

_⊎-decSetoid_ : DecSetoid -> DecSetoid -> DecSetoid
ds₁ ⊎-decSetoid ds₂ = record
  { carrier          = carrier ds₁ ⊎     carrier ds₂
  ; _≈_              = _≈_     ds₁ ⊎-Rel _≈_     ds₂
  ; isDecEquivalence = isDecEquivalence ds₁ ⊎-isDecEquivalence
                       isDecEquivalence ds₂
  }
  where open DecSetoid

_⊎-poset_ : Poset -> Poset -> Poset
po₁ ⊎-poset po₂ = record
  { carrier        = carrier        po₁ ⊎     carrier      po₂
  ; _≈_            = _≈_            po₁ ⊎-Rel _≈_          po₂
  ; _≤_            = _≤_            po₁ ⊎-Rel _≤_          po₂
  ; isPartialOrder = isPartialOrder po₁ ⊎-isPartialOrder
                     isPartialOrder po₂
  }
  where
  open Poset

_⊎-<-poset_ : Poset -> Poset -> Poset
po₁ ⊎-<-poset po₂ = record
  { carrier        = carrier        po₁ ⊎     carrier      po₂
  ; _≈_            = _≈_            po₁ ⊎-Rel _≈_          po₂
  ; _≤_            = _≤_            po₁ ⊎-<   _≤_          po₂
  ; isPartialOrder = isPartialOrder po₁ ⊎-isPartialOrder
                     isPartialOrder po₂
  }
  where
  open Poset

_⊎-<-strictPartialOrder_
  : StrictPartialOrder -> StrictPartialOrder -> StrictPartialOrder
spo₁ ⊎-<-strictPartialOrder spo₂ = record
  { carrier              = carrier      spo₁ ⊎     carrier      spo₂
  ; _≈_                  = _≈_          spo₁ ⊎-Rel _≈_          spo₂
  ; _<_                  = _<_          spo₁ ⊎-<   _<_          spo₂
  ; isStrictPartialOrder = isStrictPartialOrder spo₁
                             ⊎-isStrictPartialOrder
                           isStrictPartialOrder spo₂
  }
  where
  open StrictPartialOrder

_⊎-<-totalOrder_
  : TotalOrder -> TotalOrder -> TotalOrder
to₁ ⊎-<-totalOrder to₂ = record
  { carrier      = carrier      to₁ ⊎                carrier      to₂
  ; _≈_          = _≈_          to₁ ⊎-Rel            _≈_          to₂
  ; _≤_          = _≤_          to₁ ⊎-<              _≤_          to₂
  ; isTotalOrder = isTotalOrder to₁ ⊎-<-isTotalOrder isTotalOrder to₂
  }
  where
  open TotalOrder

_⊎-<-decTotalOrder_
  : DecTotalOrder -> DecTotalOrder -> DecTotalOrder
to₁ ⊎-<-decTotalOrder to₂ = record
  { carrier         = carrier      to₁ ⊎     carrier      to₂
  ; _≈_             = _≈_          to₁ ⊎-Rel _≈_          to₂
  ; _≤_             = _≤_          to₁ ⊎-<   _≤_          to₂
  ; isDecTotalOrder = isDecTotalOrder to₁ ⊎-<-isDecTotalOrder
                      isDecTotalOrder to₂
  }
  where
  open DecTotalOrder
