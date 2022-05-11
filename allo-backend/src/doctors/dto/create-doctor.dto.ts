import {IsEmail, IsAlpha, IsString, IsNotEmpty} from 'class-validator';

export class CreateDoctorDto {
    
    @IsString()
    @IsEmail()
    readonly email: string;

    @IsString()
    @IsNotEmpty()
    readonly password: string;

    @IsAlpha()
    @IsNotEmpty()
    readonly firstName: string;

    @IsAlpha()
    @IsNotEmpty()
    readonly lastName: string;

    @IsString()
    @IsNotEmpty()
    readonly doctorCredentialId: string;
}
