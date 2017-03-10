
if Server then
   local kRagdollTime = 10
   local function SetRagdoll(self, deathTime)

      if Server then

         if self:GetPhysicsGroup() ~= PhysicsGroup.RagdollGroup then

            self:SetPhysicsType(PhysicsType.Dynamic)

            self:SetPhysicsGroup(PhysicsGroup.RagdollGroup)

            -- Apply landing blow death impulse to ragdoll (but only if we didn't play death animation).
            if self.deathImpulse and self.deathPoint and self:GetPhysicsModel() and self:GetPhysicsType() == PhysicsType.Dynamic then

               self:GetPhysicsModel():AddImpulse(self.deathPoint, self.deathImpulse)
               self.deathImpulse = nil
               self.deathPoint = nil
               self.doerClassName = nil

            end

            if deathTime then
               self.timeToDestroy = deathTime
            end

         end

      end

   end

   function RagdollMixin:OnTag(tagName)

      PROFILE("RagdollMixin:OnTag")

      if not self.GetHasClientModel or not self:GetHasClientModel() then

         if tagName == "death_end" then

            if self.bypassRagdoll then
               self:SetModel(nil)
            else
               SetRagdoll(self, kRagdollTime)
            end

         elseif tagName == "destroy" then
            DestroyEntitySafe(self)
         end

      end

   end

end
