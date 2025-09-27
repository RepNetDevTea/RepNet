import { Inject, Injectable } from "@nestjs/common";
import { PassportStrategy } from "@nestjs/passport";
import refreshJwtConfig from "../config/refresh-jwt.config";
import type { ConfigType } from "@nestjs/config";
import { ExtractJwt, Strategy } from "passport-jwt";
import type { Request } from "express";
import { AuthService } from "../auth.service";

@Injectable()
export class RefreshJwtAuthStrategy extends PassportStrategy(Strategy, 'refresh-jwt') {
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

  async validate(req: Request, payload: any) {
    const refreshToken = req.get('Authorization')!.replace('Bearer', '').trim();
    const userId = payload.id;
    if (!this.authService.validateRefreshToken(userId, refreshToken))
      return false;

    return payload;
  }
}