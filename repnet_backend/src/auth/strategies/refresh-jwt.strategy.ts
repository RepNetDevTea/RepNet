import { Inject, Injectable } from "@nestjs/common";
import { PassportStrategy } from "@nestjs/passport";
import refreshJwtConfig from "../config/refresh-jwt.config";
import type { ConfigType } from "@nestjs/config";
import { ExtractJwt, Strategy } from "passport-jwt";
import type { Request } from "express";
import { AuthService } from "../auth.service";

@Injectable()
export class RefreshJwtAuthGuard extends PassportStrategy(Strategy) {
  constructor(
    @Inject(refreshJwtConfig.KEY)
    private refreshJwtConfiguration: ConfigType<typeof refreshJwtConfig>, 
    private authService: AuthService, 
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: refreshJwtConfiguration.secret!,
      passReqToCallback: true, 
    });
  }

  validate(req: Request, payload: any) {
    const refreshToken = req.get("authorization")!.replace('Bearer', '').trim();
    const userId = payload.id;
    return this.authService.validateRefreshToken(userId, refreshToken);
  }
}