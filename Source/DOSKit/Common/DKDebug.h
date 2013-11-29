/*
 * iDOSBox
 * Copyright (C) 2013  Matthew Vilim
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

// enable or disable debug mode
#if DEBUG
    #define DK_DEBUG 1
#else
    #define DK_DEBUG 0
#endif

// enable or disable logging
#if IDB_DEBUG
    #define DK_LOG(string, ...) NSLog((@"DOSKit: %@"), [NSString stringWithFormat:(string), ##__VA_ARGS__])
#else
    #define DK_LOG(string, ...) do {} while (0)
#endif

// enable or disable memory management logging
#define DK_LOG_INIT(object) DK_LOG(@"init %@", object)
#define DK_LOG_DEALLOC(object) DK_LOG(@"dealloc %@", object)

static NSString * const DKArgumentNilError = @"argument cannot be nil";
static NSString * const DKShouldOverrideError = @"method implementation should be overridden";
static NSString * const DKInvalidArgumentError = @"argument is invalid";